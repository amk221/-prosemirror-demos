import { DOMParser } from 'prosemirror-model';
import { EditorState } from 'prosemirror-state';
import { EditorView } from 'prosemirror-view';
import { modifier } from 'ember-modifier';
import { on } from '@ember/modifier';
import { Schema } from 'prosemirror-model';
import { TextSelection } from 'prosemirror-state';

let view;

const schema = new Schema({
  nodes: {
    doc: {
      content: 'div+'
    },
    div: {
      content: 'text*',
      attrs: {
        style: { default: null },
        width: { default: null }
      },
      toDOM(node) {
        const attrs = {};
        if (node.attrs.style) attrs.style = node.attrs.style;
        if (node.attrs.width) attrs.width = node.attrs.width;
        return ['div', attrs, 0];
      },
      parseDOM: [
        {
          tag: 'div',
          getAttrs(dom) {
            return {
              style: dom.getAttribute('style') || null,
              width: dom.getAttribute('width') || null
            };
          }
        }
      ]
    },
    text: {
      group: 'inline'
    }
  }
});

const prosemirror = modifier((element) => {
  const doc = schema.node('doc', null, [
    schema.node('div', null, [schema.text('Hello World')])
  ]);

  const state = EditorState.create({ doc });

  view = new EditorView(element, { state });
});

function replaceDoc(content) {
  return (state, dispatch) => {
    if (dispatch) {
      content.check();

      const { tr } = state;
      tr.replaceWith(0, state.doc.content.size, content);
      tr.setSelection(TextSelection.atStart(tr.doc));

      dispatch(tr);
    }

    return true;
  };
}

function htmlToNode(html) {
  const element = document.createElement('div');
  element.innerHTML = html;
  return DOMParser.fromSchema(schema).parse(element);
}

function change() {
  const node = htmlToNode('<div style="color: red;" width="100%">Hi</div>');
  const command = replaceDoc(node);
  command(view.state, view.dispatch);
}

<template>
  <div id="editor" {{prosemirror}}></div>
  <br />
  <button {{on "click" change}}>change</button>
</template>
