# -*- coding: utf-8 -*-
require 'spec_helper'
require 'erubis'
require 'bamboo-worker/template'

# Template tests
module BambooWorker
  describe 'Template' do
    it 'should render ERB template' do
      template = 'May the force be with <%= name %>.'
      data = { name: 'you' }
      output = Template.render(template, data)
      expect(output).to eq('May the force be with you.')
    end
  end
end
