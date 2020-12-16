const language = ['en', 'ja']

export class Preferences {
  constructor() {
    this.storage = localStorage
  }

  clear() {
    this.storage.clear()
  }

  toJSON() {
    return JSON.stringify({
      language: this.language(),
      sourceLanguage: this.sourceLanguage(),
      targetLanguage: this.targetLanguage(),
      saveHistories: this.saveHistories(),
      sendAnonymousData: this.sendAnonymousData()
    })
  }

  setValue(key, value) {
    this.storage[key] = value
  }

  getValue(key) {
    return this.storage[key]
  }

  accessValue(key, inputValue, defaultValue, defaultValues) {
    if (inputValue) {
      if (defaultValues.includes(inputValue)) {
        this.setValue(key, inputValue)
      }
    } else {
      return this.getValue(key) || defaultValue
    }
  }

  language(value) {
    return this.accessValue('language', value, 'en', language)
  }
}
