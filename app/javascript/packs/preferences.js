const language = ['en', 'ja']
const sourceLanguage = ['automatic', 'de', 'en', 'fr', 'es', 'it', 'ja', 'nl', 'pl', 'pt', 'pt-br', 'pt-pt', 'ru', 'ch']
const targetLanguage = ['de', 'en', 'fr', 'es', 'it', 'ja', 'nl', 'pl', 'pt', 'pt-br', 'pt-pt', 'ru', 'ch']
const saveHistories = ['yes', 'no']
const sendAnonymousData = ['yes', 'no']

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

  sourceLanguage(value) {
    return this.accessValue('sourceLanguage', value, 'automatic', sourceLanguage)
  }

  targetLanguage(value) {
    return this.accessValue('targetLanguage', value, 'en', targetLanguage)
  }

  saveHistories(value) {
    return this.accessValue('saveHistories', value, 'yes', saveHistories)
  }

  sendAnonymousData(value) {
    return this.accessValue('sendAnonymousData', value, 'yes', sendAnonymousData)
  }
}
