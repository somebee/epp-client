require 'epp-client/base'
require 'epp-client/secdns'

module EPPClient
  class Norid < Base

    # adding schema-extensions in a strange way
    SCHEMAS_NORID = %w[
      no-ext-contact-1.0
      no-ext-host-1.0
      no-ext-domain-1.0
      no-ext-domain-1.1
      no-ext-epp-1.0
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

    def schema name
      EPPClient::SCHEMAS_URL[name]
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

    #<?xml version="1.0" encoding="UTF-8" standalone="no"?>
    #<epp xmlns="urn:ietf:params:xml:ns:epp-1.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="urn:ietf:params:xml:ns:epp-1.0 epp-1.0.xsd">
    #  <command>
    #    <transfer op="request">
    #      <domain:transfer xmlns:domain="urn:ietf:params:xml:ns:domain-1.0" xsi:schemaLocation="urn:ietf:params:xml:ns:domain-1.0 domain-1.0.xsd">
    #        <domain:name>transfer-test2-5745.no</domain:name>
    #      </domain:transfer>
    #    </transfer>
    #    <extension>
    #      <no-ext-domain:transfer xmlns:no-ext-domain="http://www.norid.no/xsd/no-ext-domain-1.0" xsi:schemaLocation="http://www.norid.no/xsd/no-ext-domain-1.0 no-ext-domain-1.0.xsd">
    #        <no-ext-domain:notify>
    #          <no-ext-domain:email>pxtra2@example.no</no-ext-domain:email>
    #        </no-ext-domain:notify>
    #      </no-ext-domain:transfer>
    #    </extension>
    #    <clTRID>NORID-5948-1265060730026031</clTRID>
    #  </command>
    #</epp>

    # Object pending transfer - possible 'error'
    def domain_transfer op, domain, args = {}
      xml = domain_transfer_xml(op, domain, args)
      puts "\n--- request from transfer #{op} ---"
      puts xml

      response = send_request(xml)
      puts "\n--- response from transfer #{op} ---"
      puts response

      get_result(:xml => response, :callback => :"domain_transfer_#{op}_process")
    end

    def domain_transfer_xml op, domain, args
      return domain_transfer_execute_xml(domain,args) if op == :execute
    
      command do |xml|
        xml.transfer(op: op) do
          xml.transfer(:xmlns => schema('domain-1.0')) do xml.name domain end
        end

        if op == :request
          xml.extension do
            xml.transfer(:xmlns => schema('no-ext-domain-1.1')) do
              xml.notify do xml.email args[:email] end
            end
          end
        end
      end
    end

    def domain_transfer_execute_xml domain, args
      builder do |xml|
        xml.extension do
          xml.command(:xmlns => schema('no-ext-epp-1.0')) do
            xml.transfer(op: 'execute') do
              xml.transfer(:xmlns => schema('domain-1.0')) do 
                xml.name domain 
                xml.period({:unit => "m"}, 12) # renew for 12 months
              end
            end
            xml.extension do
              xml.transfer(:xmlns => schema('no-ext-domain-1.1')) do 
                xml.token(args[:token])
              end
            end
            xml.clTRID(clTRID)
          end
        end
      end
    end

    def domain_transfer_request_process xml
      schemas = EPPClient::SCHEMAS_URL
      dom = xml.xpath('epp:resData/domain:trnData',schemas)
      ret = {
        status: dom.xpath('domain:trStatus', schemas).text
      }
    end

    def domain_transfer_query_process xml
      schemas = EPPClient::SCHEMAS_URL
      dom = xml.xpath('epp:resData/domain:trnData',schemas)
      ret = {
        status: dom.xpath('domain:trStatus', schemas).text
      }
    end

    def domain_transfer_cancel_process xml
      schemas = EPPClient::SCHEMAS_URL
      dom = xml.xpath('epp:resData/domain:trnData',schemas)
      ret = {
        status: dom.xpath('domain:trStatus', schemas).text
      }
    end

    def domain_transfer_execute_process xml
      schemas = EPPClient::SCHEMAS_URL
      dom = xml.xpath('epp:resData/domain:trnData',schemas)
      ret = {
        status: dom.xpath('domain:trStatus', schemas).text
      }
    end

    


    # keep that at the end.
    include EPPClient::SecDNS
  end
end
