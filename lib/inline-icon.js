function inlineIcon () {
  this.process((parent, target, attrs) => {
      const icon = target;
      let theIcon = ''
      if (attrs.set === 'plenty') {
          const plentyIconColour = attrs.role || '';
          theIcon = `<span class="icon ${plentyIconColour}"><i class="psicon-${icon}"></i></span>`;
      } else if (attrs.set === 'material') {
          const materialIconColour = attrs.role || '';
          theIcon = `<span class="icon ${materialIconColour}"><i class="material-${icon}"></i></span>`;
      } else {
          const primaryIconColour = attrs.role || '';
          const rotationIconClass = attrs.rotate ? `fa-rotate-${attrs.rotate}` : '';
          const flipIconClass = attrs.flip ? `fa-flip-${attrs.flip}` : '';

          if (attrs.stack) {
              const stackClass = 'fa-stack fa-lg';
              const stackLargeIconClass = 'fa-stack-2x';
              const stackSmallIconClass = 'fa-stack-1x';
              const stack = attrs.stack;

              let stackedIcon = '';
              let stackedIconColour = 'black';
              let stackedIconPosition = '';

              stackedIcon = stack.slice(0, stack.indexOf(','));

              if (((stack.match(/,/g)) || []).length > 1) {
                  stackedIconPosition = stack.slice(stack.indexOf(',') + 1, stack.lastIndexOf(','));
                  stackedIconColour = stack.slice(stack.lastIndexOf(',') + 1);
              } else {
                  stackedIconPosition = stack.slice(stack.indexOf(',') + 1);
              }

              theIcon = `<span class="icon ${primaryIconColour} ${stackClass}"><i class="fa fa-${icon} ${stackLargeIconClass} ${rotationIconClass} ${flipIconClass}"></i><span class="icon ${stackedIconColour}"><i class="fa fa-${stackedIcon} ${stackSmallIconClass} ${stackedIconPosition}"></i></span></span>`;

          }

          theIcon = `<span class="icon ${primaryIconColour}"><i class="fa fa-${icon} ${rotationIconClass} ${flipIconClass}"></i></span>`;
      }
      return this.createInline(parent, 'quoted', theIcon ).convert()
  })
}

function register (registry) {
  registry.inlineMacro('icon', inlineIcon)
}

module.exports.register = register