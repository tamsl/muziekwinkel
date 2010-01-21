class Klant < User
  validates_presence_of :voornaam, :achternaam, :creditcard, :postcode, :huisnummer
  validates_uniqueness_of :creditcard
  validates_format_of :creditcard, :with => /\A([0-9]+)\Z/i
  validates_format_of :huisnummer, :with => /\A([-a-z0-9]+)\Z/i
  validates_length_of :postcode, :within => 6..6, :too_long => "is too long. Use 6 characters", :too_short => "is too short. Use 6 characters"
 
  has_many :aankoops
  has_many :commentaars

  attr_accessible :login, :email, :password, :password_confirmation, 
                  :voornaam, :achternaam, :creditcard, :postcode, :huisnummer

  def naam
    voornaam + ' ' + achternaam
  end

  def naam_omgekeerd
    achternaam + ', ' + voornaam
  end
end
