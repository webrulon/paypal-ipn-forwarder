require 'cgi'
require 'sinatra/base'
require 'rest_client'

require_relative 'computer'

class Server

  def ipn
    @ipn
  end

  def create_queue
    @queue = Queue.new
  end

  MAP = {
        'gpmac_1231902686_biz@paypal.com' => 'devloper_one',
        'paypal@gmail.com' => 'developmentmachine:9999/'
        }
  COMPUTERS_TESTING = {
      'developer_one' => false,
      'developmentmachine:9999/' => false
  }
  def initialize(ipn=nil)
    @ipn = ipn unless ipn.nil?
  end

  def send_ipn
    #@comp_id = id
    computer = Computer.new
    computer.send_ipn @ipn
  end

  def paypal_id
    params = CGI::parse(@ipn)
    params["receiver_email"].first
  end

  def computer_id(paypal_id)
      MAP[paypal_id]
  end

  # FIXME: This didn't merge cleanly; bet it doesn't work.
  def receive_ipn(ipn=nil)
    @ipn = ipn unless ipn.nil?
    response = IpnResponse.new(@ipn)
    response.success = 'successful' # again, find out what PayPal _really_ wants
    response
  end

  def computer_online(id)
    COMPUTERS_TESTING[id] = true
  end

  def computer_online?(id)
    COMPUTERS_TESTING[id]
  end

  def computer_offline(id)
    COMPUTERS_TESTING[id] = false
  end

  def queue_push(ipn)
    @queue.push(ipn)
  end

  def queue_size
    @queue.size
  end
end
