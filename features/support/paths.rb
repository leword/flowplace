module NavigationHelpers
  def path_to(page_name)
    case page_name
    
    when /the login page/
      '/login'
    when /the logout page/
      '/logout'
    when /the home page/
      '/'
    when /^the dashboard page$/
      '/dashboard'
    when /the flowplace dashboard page/
      '/dashboard?current_circle='
    when /the dashboard page for "([^\"]*)"/
      i = Currency.find_by_name($1)
      '/dashboard?current_circle='+i.id.to_s
    when /the holoptiview page/
      '/'
    when /the new intentions page/
      '/intentions/new'
    when /the my intentions page/
      '/intentions/my'
    when /the intentions page/
      '/intentions'
    when /the edit intentions page for "([^\"]*)"/
      title = $1
      i = Weal.find_by_title(title)
      "/intentions/#{i.id}/edit"
    when /the view intentions page for "([^\"]*)"/
      title = $1
      i = Weal.find_by_title(title)
      "/intentions/#{i.id}"
    when /the all intentions page/
      '/weals'
    when /the my proposals page/
      '/intentions/proposed'
    when /the assets page/
      '/assets'
    when /the actions page/
      '/actions'
    when /the my currencies page/
      '/my_currencies'
    when /the join currency page/
      '/my_currencies/join'
    when /the my currency accounts page/
      '/currency_accounts'
    when /the circles page/
      '/circles'
    when /the new circles page/
      '/circles/new'
    when /the edit circle page for "([^\"]*)"/
      circle = $1
      i = Currency.find_by_name(circle)
      "/circles/#{i.id}/edit"
    when /the show circle page for "([^\"]*)"/
      circle = $1
      i = Currency.find_by_name(circle)
      "/circles/#{i.id}"
    when /the current circle members page/
      "/circles/members"
    when /the players page for "([^\"]*)"/
      circle = $1
      i = Currency.find_by_name(circle)
      "/circles/#{i.id}/players"
    when /the link players page for "([^\"]*)"/
      circle = $1
      i = Currency.find_by_name(circle)
      "/circles/#{i.id}/link_players"
    when /the currencies page for "([^\"]*)"/
      circle = $1
      i = Currency.find_by_name(circle)
      "/circles/#{i.id}/currencies"
    when /the currencies page/
      '/currencies'
    when /the new currencies page/
      '/currencies/new'
    when /the new "([^\"]*)" currencies page/
      '/currencies/new?currency_type=Currency'+$1.tr(' ','')
    when /the match page/
      '/weals'
    when /the accounts page/
      '/users'
    when /the admin page/
      '/admin'
    when /^the currency account play page for "([^\"]*)$"/
      currency_accounts_paths(:play,$1)
    when /^the currency account history page for "([^\"]*)$"/
      currency_accounts_paths(:history,$1)
    when /the "([^\"]*)" play page for my "([^\"]*)" account in "([^\"]*)"/
      user = controller.current_user
      (play_name,player_class,currency_name) = [$1,$2,$3]
      currency = Currency.find_by_name(currency_name)
      raise "couldn't find currency '#{currency_name}' while building path" if currency.nil?
      currency_account = CurrencyAccount.find(:first,:conditions => ["user_id = ? and player_class = ? and currency_id = ?",user.id,player_class,currency.id])
      raise "couldn't find a currency account for #{user.user_name} as #{player_class} while building path" if currency_account.nil?
      "/currency_accounts/#{currency_account.id}/play?name=#{play_name}"
    when /the preferences page/
      "/users/#{controller.current_user.id}/preferences"
    when /the wallets page/
      '/wallets'
    when /the configurations page/
      '/configurations'
    when /the edit configurations page for "([^\"]*)"/
      config_name = $1
      c = Configuration.find_by_name(config_name)
      raise "couldn't find configuration '#{config_name}' while building path" if c.nil?
      "/configurations/#{c.id}/edit"
    else
      raise "Can't find mapping from \"#{page_name}\" to a path."
    end
  end
end

def currency_accounts_paths(kind,locator)
  ca = CurrencyAccount.find_by_name(locator)
  raise CurrencyAccount.all.collect(&:name).inspect
  raise "couldn't find currency account for '#{locator}' while building path" if ca.nil?
  case kind
  when :play
    "/currency_accounts/#{ca.id}/play"
  when :history
    "/currency_accounts/#{ca.id}/history"
  end
end

World(NavigationHelpers)
