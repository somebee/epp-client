module EPPClient
  module Host

    def host_create(args)
      response = send_request(host_create_xml(args))
      get_result(:xml => response, :callback => :host_create_process)
    end

    def host_create_xml(args)
      command do |xml|
        xml.create do
          xml.create('xmlns' => EPPClient::SCHEMAS_URL['host-1.0']) do
            xml.name(args[:name])
            xml.addr(args[:ip], ip: 'v4') if args[:ip]
          end
        end
      end
    end

    def host_create_process(args)
      pp 'host_create_process',args
      return true
    end
  end
end

###
# <?xml version="1.0" encoding="UTF-8" standalone="no"?>
# <epp xmlns="urn:ietf:params:xml:ns:epp-1.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="urn:ietf:params:xml:ns:epp-1.0 epp-1.0.xsd">
#   <command>
#     <create>
#       <host:create xmlns:host="urn:ietf:params:xml:ns:host-1.0" xsi:schemaLocation="urn:ietf:params:xml:ns:host-1.0 host-1.0.xsd">
#         <host:name>ns1-5745.example-seq.no</host:name>
#         <host:addr ip="v4">1.2.3.1</host:addr>
#       </host:create>
#     </create>
#     <extension>
#       <no-ext-host:create xmlns:no-ext-host="http://www.norid.no/xsd/no-ext-host-1.0" xsi:schemaLocation="http://www.norid.no/xsd/no-ext-host-1.0 no-ext-host-1.0.xsd">
#         <no-ext-host:contact>PEO41P</no-ext-host:contact>
#       </no-ext-host:create>
#     </extension>
#     <clTRID>NORID-5810-1265060696518223</clTRID>
#   </command>
# </epp>

# <?xml version="1.0" encoding="UTF-8" standalone="no"?>
# <epp xmlns="urn:ietf:params:xml:ns:epp-1.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="urn:ietf:params:xml:ns:epp-1.0 epp-1.0.xsd">
#   <response>
#     <result code="1000">
#       <msg>Command completed successfully</msg>
#     </result>
#     <msgQ count="95" id="5862727"/>
#     <resData>
#       <host:creData xmlns="urn:ietf:params:xml:ns:host-1.0" xmlns:host="urn:ietf:params:xml:ns:host-1.0" xsi:schemaLocation="urn:ietf:params:xml:ns:host-1.0 host-1.0.xsd">
#         <host:name>ns1-5745.example-seq.no</host:name>
#         <host:crDate>2010-02-01T21:44:56.52Z</host:crDate>
#       </host:creData>
#     </resData>
#     <trID>
#       <clTRID>NORID-5810-1265060696518223</clTRID>
#       <svTRID>20100201224456514541-jfg96t-reg9094-NORID</svTRID>
#     </trID>
#   </response>
# </epp>