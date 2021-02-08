import React from 'react';
import ReactDOM from 'react-dom';

const render = (node) => {
  // const componentsMap = new Map([
  //   ["CallableComponent1", CallableComponent1],
  //   ["CallableComponent2", CallableComponent2],
  // ]);
  // const DynamicComponent = componentsMap.get(
  //   node.dataset.widgetType.split('-')[1],
  // );
  try {
    if (node) {
      ReactDOM.render(
        <div>
          hello
          {node.dataset.token}
        </div>,
        //         <DynamicComponent token={node.dataset.token} />,
        node.appendChild(document.createElement('div')),
      );
    }
  } catch (error) {
    // eslint-disable-next-line no-console
    console.warn(error);
  }
};

document.querySelectorAll('[data-widget-type|="naas"]').forEach((node) => {
  render(node);
});
