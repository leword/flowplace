require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  before(:each) do
    @valid_attributes = {
      :user_name => "user",
      :first_name => "value for first_name",
      :last_name => "value for last_name",
      :email => "some@email.com"
    }
  end

  it "should create a new instance given valid attributes" do
    User.create!(@valid_attributes)
  end
    
  describe 'retreiving weals' do
    before(:each) do
      @user = create_user
      @weal  = Weal.create!(:title => "title",:requester_id=>@user.id)
      @wealf = Weal.create!(:title => "title2",:offerer_id=>@user.id)
      @wealx = Weal.create!(:title => "title3",:requester_id=>999)
    end
    
    it "should be able to return a list of its requester weals" do
      @user.weals_as_requester.should == [@weal]
    end

    it "should be able to return a list of its offerer weals" do
      @user.weals_as_offerer.should == [@wealf]
    end
    
    it "should be able to return a list of its weals" do
      @user.weals.should == [@weal,@wealf]
    end
    describe 'intention and action methods' do
      before(:each) do
        @wealf.phase = 'action'
        @wealf.save
      end
      
      it "should return intentions declared" do
        @user.intentions.should == [@weal]
      end

      it "should return actions" do
        @user.actions.should == [@wealf]
      end

      it "should also return intentions proposed" do
        @p = Proposal.create!(:user_id => @user.id,
          :description => "my proposal",
          :as => "offerer",
          :weal_id => @wealx.id
          )
        @user.proposals.should == [@p]
        @user.intentions.should == [@weal,@wealx]
      end
    end    
  end
  describe 'users and currency' do
    before(:each) do
      @user = create_user
      @usd = create_currency("USD",:klass=>CurrencyTracked)
    end
    it "should return the user's currency accounts" do
      @user.currency_accounts.should == []
      @user.currencies.should == []
      @user.currency_accounts << CurrencyAccount.new(:currency => @usd)
      @user.currency_accounts[0].currency.should == @usd
      @user.currencies.should == [@usd]
    end
    it "should return the user's currency accounts in a given circle" do
      @circle = CurrencyMembrane.create(@user,{:circle=>{:name => 'a circle'},:password=>'password',:confirmation=>'password',:email=>'test@test.com'})
      @user.reload
      @user.currency_accounts << CurrencyAccount.new(:currency => @usd)
      @user.currency_accounts.size.should == 2
      @user.circle_memberships.should == [@circle]
      @circle.add_player_to_circle('member',@user)
      @user.currency_accounts << CurrencyAccount.new(:currency => @usd)
      @user.currency_accounts_in_circle(@circle).should == [@user.currency_accounts[0]]
    end
    it "should be able to return a list of currencies a user can join" do
      @user.joinable_currencies.should == [@usd]
    end
    it "should be able to test if a user has joined a given currency" do
      @user.has_joined?(@usd).should be_false
      @user.currency_accounts << CurrencyAccount.new(:currency => @usd)
      @user.has_joined?(@usd).should be_true
    end
    it "should be able to return a list of the user's player classes in a given currency" do
      @user.player_clasess_in(@usd).should == []
      @user.currency_accounts << CurrencyAccount.new(:currency => @usd,:player_class =>'member')
      @user.player_clasess_in(@usd).should == ['member']
      @user.currency_accounts << CurrencyAccount.new(:currency => @usd,:player_class =>'friend')
      @user.player_clasess_in(@usd).should == ['member','friend']
    end
    it "should be able to list a user's membership in membrane currencies" do
      @user.circle_memberships.should == []
      @user.currency_accounts.size.should == 0
      @circle = CurrencyMembrane.create(@user,{:circle=>{:name => 'a circle'},:password=>'password',:confirmation=>'password',:email=>'test@test.com'})
      @user.reload
      @user.currency_accounts.size.should == 1
      @user.circle_memberships.should == [@circle]
      @circle.add_player_to_circle('member',@user)
      @user.reload
      @user.currency_accounts.size.should == 2
      @user.circle_memberships.should == [@circle]
    end
      
  end
  
end
