# *-* coding: utf-8 -*-
require 'spec_helper'
require 'bamboo-worker/core/string/indent'

describe 'String' do
  it 'should indent' do
    expect('test'.indent(1)).to eq('  test')
    expect('test'.indent(2)).to eq('    test')
  end

  it 'should not accept negative value' do
    expect { 'test'.indent(-1) }.to raise_error(ArgumentError)
  end

  it 'should not accept string value' do
    expect { 'test'.indent('a') }.to raise_error(TypeError)
  end
end
