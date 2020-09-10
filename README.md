# RxSideDish

코드스쿼드 반찬 서비스 iOS 앱 RxSwift 리팩토링

<p align="center"><img width=500 src="demo.gif"></p>

## 목차

- [리팩토링 내용 정리](#리팩토링-내용-정리)
    - [1주차 | 메인페이지 ViewModel Binding하기](#1주차--메인페이지-ViewModel-Binding하기)
        - [RxCocoa TableView 리서치](#RxCocoa-TableView-리서치)
        - [RxDataSource 리서치](#RxDataSource-리서치)
        - [테이블뷰 섹션 업데이트 트러블슈팅](#테이블뷰-섹션-업데이트-트러블슈팅)
        - [Peer Review](#Peer-Review)
- [References](#References)

## 리팩토링 내용 정리

### 1주차 | 메인페이지 ViewModel Binding하기

- 테이블뷰 섹션별로 업데이트 기능 리팩토링
- 테이블뷰 셀 선택 시 화면 전환 기능 리팩토링

#### RxCocoa TableView 리서치

RxCocoa에서는 테이블뷰 델리게이트의 여러 이벤트들에 대한 reactive wrapper를 제공한다. [UITableView+Rx.swift][UITableView+Rx]

- `tableView:didSelectRowAtIndexPath:` → `itemSelected`
- `tableView:didDeselectRowAtIndexPath:` → `itemDeselected`

`modelSelected(_:)`, `modelDeselected(_:)`는 테이블뷰의 선택/취소된 row에 해당하는 모델 객체를 방출한다. item* 메서드는 바인드 없이 사용 가능한데, model* 메서드들은 다음과 같이 테이블뷰에 데이터를 바인드하는 작업 후에 사용이 가능하다.

```swift
Observable.of(["Lisbon", "Copenhagen", "London", "Madrid", "Vienna"])
    .bind(to: tableView.rx.items) { (tableView, row, element) in
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = element
        return cell
    }
```

하지만 [UITableView+Rx.swift][UITableView+Rx]과 [RxTableViewReactiveArrayDataSource.swift][RxTableViewReactiveArrayDataSource]를 살펴보면 RxCocoa에서 제공하는 `tableView.rx.items`는 테이블뷰의 섹션이 하나일 때만 사용이 가능한 것으로 확인된다.

#### RxDataSource 리서치

RxDataSource를 사용하면(Dependency 추가 필요) 여러 개의 섹션을 가진 테이블뷰에 데이터를 바인딩 가능하며, 데이터의 변경된 부분을 자동으로 알아내어 추가되거나 삭제되는 애니메이션도 알아서 처리해준다.

[RxDataSource][RxDataSource]의 Example 프로젝트를 살펴본 결과,

예를 들어 테이블뷰의 itemDeleted 이벤트(RxCocoa 제공)를 받아 모델을 변경(개발자가 구현 필요) 후 `tableView.rx.items(dataSource:)`에 바인드하는 스트림을 만들면 자동으로 변경된 부분을 찾아서 업데이트 해주며, 선택적으로 애니메이션 표시가 가능하다.

- 하지만 학습을 위해서 일단은 추가 라이브러리이니 RxDataSource를 사용하지 않고, 뷰모델에서 특정 섹션 업데이트에 대한 observable를 제공하도록 구현한 뒤에 이 이벤트를 받아서 직접 `tableView.reloadSections()`에 연결해 볼 예정
- 구현해야 하는 테이블뷰가 여러 section을 갖고 있어서 RxCocoa에서 제공해주는 테이블뷰에 데이터를 바인딩하는 기능도 사용할 수 없으므로 UIKit의 UITableViewDataSource를 그대로 사용하고, 바인딩 없이 사용 가능한 `tableView.rx.itemSelected`만 사용 예정

#### 테이블뷰 섹션 업데이트 트러블슈팅

현재 `main`, `soup`, `side` 3가지 API 요청 후 응답이 오면 온 순서대로 모델 업데이트 후 테이블뷰의 해당 섹션 reload 요청을 한다. 예를 들어 `main`에 대한 응답이 오면 모델에 데이터를 추가 후 섹션 0번을 reload하여 테이블뷰에 보여준다.

하지만 테이블뷰의 경우 reload 요청을 하지 않은 섹션의 모델이 바뀌어 있으면 invalid update 에러가 발생한다.

![tableview-crash](diagrams/tableview-crash.png)

위 그림에서와 같이, 테이블뷰 섹션 0, 1, 2번 중 Response C에 해당하는 테이블뷰의 섹션 2번을 reload 요청했는데, Response A 때문에 섹션 0번에 해당하는 모델도 변경되어 있어서 크래시가 발생한다.

다음 그림과 같이 API 응답에 따른 모델 변경과 애니메이션을 동기적으로 처리하여 해결하려고 시도했다.

![tableview-sync](diagrams/tableview-sync.png)

##### ConcatMap 사용 시도

API 응답에 따른 모델 변경과 애니메이션을 동기적으로 처리하기 위해 ConcatMap을 사용하여 이전 옵저버블의 onCompleted가 호출된 후 다음 옵저버블을 실행해보려 하였다.

```swift
extension Reactive where Base: UITableView {

    func reloadSections(
        _ sections: IndexSet,
        with rowAnimation: UITableView.RowAnimation
    ) -> Observable<Void> {
        return Observable.create { observer in
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                observer.onCompleted()
            }
            self.base.reloadSections(sections, with: rowAnimation)
            CATransaction.commit()
            return Disposables.create()
        }
    }
}

// tableView.rx.reloadSections()
```

다음과 같이 `concatMap`을 이용하여 애니메이션이 끝난 후 onCompleted가 방출되어 다음 뷰모델 업데이트를 처리할 수 있도록 하려 했다.

```swift
Observable.concatMap {
    // viewModel update 1, reload section 1, viewModel update 0, reload section 0, ...
}
```

하지만 뷰모델을 업데이트할 옵저버블들은 concatMap을 호출하는 시점에 한 번에 만들 수 없고, API 응답이 올때 데이터가 생겨서 만들 수 있게 되므로 실패. 또한 어떤 API 응답이 먼저 올지도 concatMap을 호출하는 시점엔 모른다. 작업이 들어올 때마다 시리얼 큐에 저장하여 순서대로 실행하는 방향이 더 적합하다는 생각이 들었다.

##### SerialDispatchQueueScheduler 사용하여 해결

```swift
// 시리얼 큐
private let queue = DispatchQueue(label: "sidedish.networking")

// 테이블뷰 section update 알림 구독
viewModel?.sectionUpdate
    .subscribeOn(SerialDispatchQueueScheduler(queue: queue, internalSerialQueueName: "update"))
    .catchErrorJustReturn(IndexSet(0..<0))
    .subscribe(onNext: { [weak self] in self?.reloadSynchronously(self?.tableView, at: $0) })
    .disposed(by: disposeBag)

// 테이블뷰 Reload
private func reloadSynchronously(_ tableView: UITableView?, at indexSet: IndexSet) {
    DispatchQueue.main.sync { tableView?.reloadSections(indexSet, with: .automatic) }
}

// 네트워크 응답 도착 시 뷰모델 업데이트
private func fetchSideDishes() {
    SideDishUseCase().fetchSideDishes { index, sideDishes in
        self.queue.sync {
            self.viewModel?.update(category: index, sideDishes: sideDishes)
        }
    }
}
```

시리얼 큐를 하나 만들고, 발행을 이 큐에서 하도록 `subscribeOn`을 사용하여 설정했다. onNext 이벤트에서는 동기적으로 뷰를 업데이트하는 메서드를 호출한다. 백그라운드 스레드에서 이벤트가 발행되므로 백그라운드 스레드에서 이 메서드를 호출하며, 이 메서드 안에서 reload 애니메이션은 메인 스레드에 sync로 보내진다.

이렇게 하면 테이블뷰 reload 애니메이션이 끝날 때까지 백그라운드 스레드가 blocking되어 다음 뷰모델 변경작업을 수행하지 않는다.

UI 바인딩 기능이지만 백그라운드 스레드에서 동작해야 해서 Driver를 사용하지 않았으므로 에러가 났을 때 스트림이 끊기지 않도록 에러 처리도 추가하였다.

#### Peer Review





## References

- [스터디 진행 스프레드시트][spreadsheet]
- [RxSwift/UITableView+Rx.swift][uitableview+rx]
- [RxTableViewReactiveArrayDataSource.swift][RxTableViewReactiveArrayDataSource]
- [RxDataSource][RxDataSource]

[spreadsheet]: https://docs.google.com/spreadsheets/d/1b7fGROHrgzJ80YjxaaAlRoj1XyLpZCFHk5xeK-yKW4I/edit#gid=0
[UITableView+Rx]: https://github.com/ReactiveX/RxSwift/blob/master/RxCocoa/iOS/UITableView%2BRx.swift
[RxDataSource]: https://github.com/RxSwiftCommunity/RxDataSources
[RxTableViewReactiveArrayDataSource]: https://github.com/ReactiveX/RxSwift/blob/master/RxCocoa/iOS/DataSources/RxTableViewReactiveArrayDataSource.swift

