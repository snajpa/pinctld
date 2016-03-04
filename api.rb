require 'haveapi'
require 'json'
require './pins.rb'

module PinAPI
  class Pin < HaveAPI::Resource
    version 1
    desc 'Manage pins'

    params(:id) do
      id :id, label: 'Pin ID'
    end

    params(:common) do
      string :desc, desc: 'Pin description'
      bool :on, desc: 'Pin state'
    end

    class Index < HaveAPI::Actions::Default::Index
      desc 'List all pins'
      output(:hash_list) do
        use :id
        use :common
      end
      authorize do |u|
        allow
      end
      def exec
        out = []
        $pins.each_index do |i|
          out << $pins[i].merge({id: i, on: is_on})
        end
        out
      end
    end

    class Show < HaveAPI::Actions::Default::Show
      output(:hash) do
        use :id
        use :common
      end
      authorize do |u|
        allow
      end
      def exec
        pin_id = params[:pin_id].to_i
        return error if pin_id > $pincount
        $pins[pin_id].merge({id: pin_id, on: pin_is_on?(pin_id)})
      end
    end

    class On < HaveAPI::Action
      desc 'Set pin on'
      route ":pin_id/on"
      http_method :post
      authorize do |u|
       allow
      end
      def exec
        pin_id = params[:pin_id].to_i
        return error if pin_id > $pincount
        pin_set_on pin_id
      end
    end
    
    class Off < HaveAPI::Action
      desc 'Set pin off'
      route ":pin_id/off"
      http_method :post
      authorize do |u|
       allow
      end
      def exec
        pin_id = params[:pin_id].to_i
        return error if pin_id > $pincount
        pin_set_off pin_id
      end
    end
    
    class Toggle < HaveAPI::Action
      desc 'Toggle pin'
      route ":pin_id/toggle"
      http_method :post
      authorize do |u|
       allow
      end
      def exec
        pin_id = params[:pin_id].to_i
        return error if pin_id > $pincount
        if pin_is_on? pin_id
          pin_set_off pin_id
          pin_set_on pin_id
        else
          pin_set_on pin_id
          pin_set_off pin_id
        end
      end
    end
  end
end

class BasicAuth < HaveAPI::Authentication::Basic::Provider
  def find_user(request, username, password)
    return true if username == $config[:username] && password == $config[:password]
    false
  end
end
