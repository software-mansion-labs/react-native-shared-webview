import ExpoModulesCore

struct Options: Record {
  @Field
  var focused: Bool = false

  @Field
  var url: String?
}

public class SharedWebviewModule: Module {
  public func definition() -> ModuleDefinition {
    Name("SharedWebview")

    View(SharedWebviewView.self) {
      Events("onNavigation")
      Prop("options") { (view: SharedWebviewView, prop: Options) in
        view.setUrl(url: prop.url ?? "")
        view.setFocused(focused: prop.focused)
      }
    }
  }
}
