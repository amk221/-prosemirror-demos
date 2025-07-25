import { DOMParser } from 'prosemirror-model';
import { EditorState } from 'prosemirror-state';
import { EditorView } from 'prosemirror-view';
import { modifier } from 'ember-modifier';
import { on } from '@ember/modifier';
import { Schema } from 'prosemirror-model';
import { TextSelection } from 'prosemirror-state';

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
    schema.node(
      'div',
      {
        style: 'color: red',
        width: '100%'
      },
      [schema.text('Hello World')]
    )
  ]);

  const state = EditorState.create({ doc });

  const view = new EditorView(element, { state });
});

<template>
  <div id="editor" {{prosemirror}}></div>
</template>
