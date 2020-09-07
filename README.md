# RxSideDish

코드스쿼드 반찬 서비스 iOS 앱 RxSwift 리팩토링

<p align="center"><img width=500 src="demo.gif"></p>

## 리팩토링 내용 정리

### 메인페이지 ViewModel Binding하기

- 테이블뷰 섹션별로 업데이트 기능 리팩토링
- 테이블뷰 셀에 데이터 표시 기능 리팩토링
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

