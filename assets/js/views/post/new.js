import MainView from '../main'

export default class PostEditorView extends MainView {
  mount() {
    super.mount()
    console.log("PostEditorView mounted")
  }

  unmount() {
    super.unmount()
    console.log("PostEditorView unmounted")
  }
}
