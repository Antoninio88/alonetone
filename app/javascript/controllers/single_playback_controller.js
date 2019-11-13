import PlaybackController from './playback_controller'

export default class extends PlaybackController {
  preInitialize() {
    this.url = this.playTarget.getAttribute('href')
    this.preload = true
  }

  playCallback(e) {
    if (!this.bigPlay) this.setBigPlay()
    this.bigPlay.setAnimationState()
    this.registeredListen = false
  }

  pauseCallback() {
    this.bigPlay.pause()
  }

  stopCallback() {
    this.bigPlay.stop()
  }

  whilePlayingCallback() {
    if (!this.bigPlay) this.setBigPlay()
    if (!this.loaded) {
      this.loaded = true
      this.bigPlay.play()
    }
    this.bigPlay.update(this.percentPlayed())
  }

  setBigPlay() {
    this.bigPlay = this.application.getControllerForElementAndIdentifier(document.querySelector('.track_content'), 'big-play')
  }
}