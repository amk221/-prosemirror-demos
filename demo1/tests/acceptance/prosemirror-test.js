import { module, test } from 'qunit';
import { visit, fillIn } from '@ember/test-helpers';
import { setupApplicationTest } from 'prosemirror-demo1/tests/helpers';

module('Demo', function (hooks) {
  setupApplicationTest(hooks);

  test('fillIn', async function (assert) {
    await visit('/');
    await fillIn('.ProseMirror', '<b>Test</b>');

    assert.dom('.ProseMirror').hasHtml('<p><b>Test</b></p>');
  });
});
