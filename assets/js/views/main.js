import "phoenix_html"
import Prism from "prismjs"
import {initBurger} from '../burger'

export default class MainView {
  mount() {
    initBurger()
    Prism.highlightAll()

    // This will be executed when the document loads...
    console.log('MainView mounted');
  }

  unmount() {
    // This will be executed when the document unloads...
    console.log('MainView unmounted');
  }
}
