class ActionController::TestCase
  def assert_assigns_valid(name, test_context=nil)
    value = assigns name
    value.must_be :valid?, value.errors.full_messages.join(', ')
    instance_variable_set "@#{name}", value
  end

  alias :must_protect_actions :assert_protect_actions

  def assert_protect_actions(opts)
    redirect_path = opts[:redirecting_to]
    assert redirect_path, 'Missing authorization redirection path'

    actions     = opts[:actions] || {
      index:    { method: :get,     params: { }       },
      new:      { method: :get,     params: { }       },
      create:   { method: :post,    params: { }       },
      show:     { method: :get,     params: { id: 1 } },
      edit:     { method: :get,     params: { id: 1 } },
      update:   { method: :put,     params: { id: 1 } },
      destroy:  { method: :delete,  params: { id: 1 } }
    }

    if opts[:singular]
      actions.delete :index
      actions.each { |_, action_opts| action_opts[:params].delete :id }
    end

    actions.each do |action, action_opts|
      method, params = action_opts[:method], action_opts[:params]

      send method, action, params

      assert_redirected_to redirect_path,
        "#{method.upcase} #{action} didn't redirect to #{redirect_path}"

      assert_equal opts[:alert], flash[:alert] if opts.has_key? :alert
    end
  end
end
