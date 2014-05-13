require 'epp-client/base'
require 'epp-client/secdns'

module EPPClient
  class Norid < Base

    # adding schema-extensions in a strange way
    SCHEMAS_NORID = %w[
      no-ext-contact-1.0
      no-ext-host-1.0
      no-ext-domain-1.1
    ]

    EPPClient::SCHEMAS_URL.merge!(SCHEMAS_NORID.inject({}) do |a,s|
      a[s.sub(/-1\.0$/, '')] = "http://www.norid.no/xsd/#{s}" if s =~ /-1\.0$/
      a[s] = "http://www.norid.no/xsd/#{s}"
      a
    end)

    #
    # Sets the default for Norid, that is, server and port, according
    # to Norid's documentation.
    #
    # ==== Required Attributes
    #
    # [<tt>:client_id</tt>] the tag or username used with <tt><login></tt> requests.
    # [<tt>:password</tt>] the password used with <tt><login></tt> requests.
    # [<tt>:ssl_cert</tt>] the file containing the client certificate.
    # [<tt>:ssl_key</tt>] the file containing the key of the certificate.
    #
    # ==== Optional Attributes
    # [<tt>:test</tt>] sets the server to be the test server.
    #
    # See EPPClient for other attributes.
    def initialize(attrs)
      unless attrs.key?(:client_id) && attrs.key?(:password) # && attrs.key?(:ssl_cert) && attrs.key?(:ssl_key)
        raise ArgumentError, "client_id and password are required"
      end
      if attrs.delete(:test) == true
        attrs[:server] ||= 'epp.test.norid.no'
        attrs[:port] ||= 700
      else
        attrs[:server] ||= 'epp.norid.no'
        attrs[:port] ||= 700
      end
      @services = EPPClient::SCHEMAS_URL.values_at('domain', 'contact')
      super(attrs)
      @extensions << EPPClient::SCHEMAS_URL['no-ext-contact']
    end

    # Extends the EPPClient::Contact#contact_info so that the specific
    # smallregistry's informations are processed, the additionnal informations
    # are :
    #
    # one of :
    # [<tt>:org</tt>]
    #   indicating that the contact is an organisation with the following
    #   informations :
    #   [<tt>:companySerial</tt>]
    #     the company's SIREN / RPPS / whatever serial number is required.
    # [<tt>:person</tt>]
    #   indicating that the contact is a human person with the following
    #   informations :
    #   [<tt>:birthDate</tt>] the person's birth date.
    #   [<tt>:birthPlace</tt>] the person's birth place.
    def contact_info(xml)
      super # placeholder so that I can add some doc
    end

#    def contact_info_process(xml) #:nodoc:
#
#      #<extension>
#      #  <no-ext-contact:create xmlns:no-ext-contact="http://www.norid.no/xsd/no-ext-contact-1.0" xsi:schemaLocation="http://www.norid.no/xsd/no-ext-contact-1.0 no-ext-contact-1.0.xsd">
#      #    <no-ext-contact:type>organization</no-ext-contact:type>
#      #    <no-ext-contact:identity type="organizationNumber">894786892</no-ext-contact:identity>
#      #    <no-ext-contact:mobilePhone>+47.123456780</no-ext-contact:mobilePhone>
#      #    <no-ext-contact:email>xtra1@example.no</no-ext-contact:email>
#      #    <no-ext-contact:email>xtra2@example.no</no-ext-contact:email>
#      #  </no-ext-contact:create>
#      #</extension>
#
#      ret = super
#      if (contact = xml.xpath('epp:extension/sr:ext/sr:infData/sr:contact', EPPClient::SCHEMAS_URL)).size > 0
#        if (person = contact.xpath('sr:person', EPPClient::SCHEMAS_URL)).size > 0
#          ret[:person] = {
#            :birthDate => Date.parse(person.xpath('sr:birthDate', EPPClient::SCHEMAS_URL).text),
#            :birthPlace => person.xpath('sr:birthPlace', EPPClient::SCHEMAS_URL).text,
#          }
#        end
#        if (org = contact.xpath('sr:org', EPPClient::SCHEMAS_URL)).size > 0
#          ret[:org] = { :companySerial => org.xpath('sr:companySerial', EPPClient::SCHEMAS_URL).text }
#        end
#      end
#      ret
#    end

    # Extends the EPPClient::Contact#contact_create so that the specific
    # smallregistry's information are sent, the additionnal informations are :
    #
    # one of :
    # [<tt>:org</tt>]
    #   indicating that the contact is an organisation with the following
    #   informations :
    #   [<tt>:companySerial</tt>]
    #     the company's SIREN / RPPS / whatever serial number is required.
    # [<tt>:person</tt>]
    #   indicating that the contact is a human person with the following
    #   informations :
    #   [<tt>:birthDate</tt>] the person's birth date.
    #   [<tt>:birthPlace</tt>] the person's birth place.
    def contact_create(contact)
      super
      # super # placeholder so that I can add some doc
      # xml = contact_create_xml(contact)
      # response = send_request(xml)
      # get_result(:xml => response, :callback => :contact_create_process)
    end

    def host_create_xml(args)
      ext = extension do |xml|
        xml.tag!("create",  :xmlns => EPPClient::SCHEMAS_URL['no-ext-host']) do
          xml.contact(val) if val = args[:contact]
        end
      end
      insert_extension(super, ext)
      # <extension>
      #       <no-ext-host:create xmlns:no-ext-host="http://www.norid.no/xsd/no-ext-host-1.0" xsi:schemaLocation="http://www.norid.no/xsd/no-ext-host-1.0 no-ext-host-1.0.xsd">
      #         <no-ext-host:contact>PEO41P</no-ext-host:contact>
      #       </no-ext-host:create>
      #     </extension>
    end

    def contact_create_xml(contact) #:nodoc:
      #<extension>
      #  <no-ext-contact:create xmlns:no-ext-contact="http://www.norid.no/xsd/no-ext-contact-1.0" xsi:schemaLocation="http://www.norid.no/xsd/no-ext-contact-1.0 no-ext-contact-1.0.xsd">
      #    <no-ext-contact:type>organization</no-ext-contact:type>
      #    <no-ext-contact:identity type="organizationNumber">894786892</no-ext-contact:identity>
      #    <no-ext-contact:mobilePhone>+47.123456780</no-ext-contact:mobilePhone>
      #    <no-ext-contact:email>xtra1@example.no</no-ext-contact:email>
      #    <no-ext-contact:email>xtra2@example.no</no-ext-contact:email>
      #  </no-ext-contact:create>
      #</extension>

      ret = super
      ns = 'no-ext-contact'
      prefix = "" # no-ext-contact:
      ext = extension do |xml|
        xml.tag!("#{prefix}create",  :xmlns => EPPClient::SCHEMAS_URL['no-ext-contact']) do
          if contact[:type] == 'org'
            xml.type 'organization'
            xml.identity contact[:identity], type: "organizationNumber"
            # xml.tag!("#{prefix}type",'organization')
            # xml.tag!("#{prefix}identity",contact[:org], type: "organizationNumber")
          elsif contact[:type] == 'person'
            # xml.tag!("#{prefix}type",'person')
            xml.type 'person'
            if val = contact[:org]
              xml.organization(val)
            end

          end
        end
      end

      insert_extension(ret, ext)
    end

    def domain_create_xml(args)
      applicant = args[:applicant]
      ext = extension do |xml|
        xml.create(:xmlns => EPPClient::SCHEMAS_URL['no-ext-domain-1.1']) do
          xml.applicantDataset do
            xml.versionNumber applicant[:rev] or '2.0'
            xml.acceptName applicant[:name]
            xml.acceptDate applicant[:date].strftime("%FT%R:%SZ")
          end
        end
      end
      insert_extension(super, ext)
      #      <extension>
      #   <no-ext-domain:create xmlns:no-ext-domain="http://www.norid.no/xsd/no-ext-domain-1.1" xsi:schemaLocation="http://www.norid.no/xsd/no-ext-domain-1.1 no-ext-domain-1.1.xsd">
      #    <no-ext-domain:applicantDataset>
      #     <no-ext-domain:versionNumber>2.0</no-ext-domain:versionNumber>
      #     <no-ext-domain:acceptName>Ola Nordmann</no-ext-domain:acceptName>
      #     <no-ext-domain:acceptDate>2012-06-04T14:31:43Z</no-ext-domain:acceptDate>
      #    </no-ext-domain:applicantDataset>
      #   </no-ext-domain:create>
      #  </extension>
      
    end

    # keep that at the end.
    include EPPClient::SecDNS
  end
end
