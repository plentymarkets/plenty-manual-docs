function cautionToWarningBlock () {
  this.process((doc, output) => {
      return output.replace(/admonitionblock\scaution/g, 'admonitionblock warning')
    })
}

function register (registry) {
  registry.postprocessor(cautionToWarningBlock)
}
  
module.exports.register = register
