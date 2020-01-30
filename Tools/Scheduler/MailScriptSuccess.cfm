
<cfoutput>

<cfif !isDefined("Parameter.DateFormat")>

	<cfquery name="Parameter"  datasource="AppsSystem">
	    SELECT * 
		FROM Parameter
	</cfquery>

</cfif>

<cfif Parameter.DateFormat is "EU">
     <cfset CLIENT.DateFormatShow      = "dd/mm/yyyy">
<cfelse> 
     <cfset CLIENT.DateFormatShow      = "mm/dd/yyyy">
</cfif>


<cfif Last.ActionStatus eq "2">
   <cfset result = "COMPLETION WITH ERROR:">
<cfelse>
   <cfset result = "SUCCESS:">
</cfif>

<cfif Template.ScriptSuccessMail neq "">
		
		<cfset headercolor = "ffffff">

		<cfmail TO          = "#Template.ScriptSuccessMail#"
		        FROM        = "#SESSION.welcome# Task Agent <#Template.ScriptSuccessMail#>"
				ReplyTo     = "#Template.ScriptSuccessMail#"
				SUBJECT     = "#result# #Template.ScheduleName#"
				mailerID    = "#SESSION.welcome#"
				TYPE        = "html"
				spoolEnable = "Yes"
				wraptext    = "100">
									
       
            
            
            
    <style media="all" type="text/css">
    @media only screen and (max-width: 640px) {
      .span-2,
      .span-3 {
        float: none !important;
        max-width: none !important;
        width: 100% !important;
      }
      .span-2 > table,
      .span-3 > table {
        max-width: 100% !important;
        width: 100% !important;
      }
    }
    
    @media all {
      .btn-primary table td:hover {
        background-color: ##34495e !important;
      }
      .btn-primary a:hover {
        background-color: ##34495e !important;
        border-color: ##34495e !important;
      }
    }
    
    @media all {
      .btn-secondary a:hover {
        border-color: ##34495e !important;
        color: ##34495e !important;
      }
    }
    
    @media only screen and (max-width: 640px) {
      h1 {
        font-size: 36px !important;
        margin-bottom: 16px !important;
      }
      h2 {
        font-size: 28px !important;
        margin-bottom: 8px !important;
      }
      h3 {
        font-size: 22px !important;
        margin-bottom: 8px !important;
      }
      .main p,
      .main ul,
      .main ol,
      .main td,
      .main span {
        font-size: 16px !important;
      }
      .wrapper {
        padding: 8px !important;
      }
      .article {
        padding-left: 8px !important;
        padding-right: 8px !important;
      }
      .content {
        padding: 0 !important;
      }
      .container {
        padding: 0 !important;
        padding-top: 8px !important;
        width: 100% !important;
      }
      .header {
        margin-bottom: 8px !important;
        margin-top: 0 !important;
      }
      .main {
        border-left-width: 0 !important;
        border-radius: 0 !important;
        border-right-width: 0 !important;
      }
      .btn table {
        max-width: 100% !important;
        width: 100% !important;
      }
      .btn a {
        font-size: 16px !important;
        max-width: 100% !important;
        width: 100% !important;
      }
      .img-responsive {
        height: auto !important;
        max-width: 100% !important;
        width: auto !important;
      }
      .alert td {
        border-radius: 0 !important;
        font-size: 16px !important;
        padding-bottom: 16px !important;
        padding-left: 8px !important;
        padding-right: 8px !important;
        padding-top: 16px !important;
      }
      .receipt,
      .receipt-container {
        width: 100% !important;
      }
      .hr tr:first-of-type td,
      .hr tr:last-of-type td {
        height: 16px !important;
        line-height: 16px !important;
      }
    }
    
    @media all {
      .ExternalClass {
        width: 100%;
      }
      .ExternalClass,
      .ExternalClass p,
      .ExternalClass span,
      .ExternalClass font,
      .ExternalClass td,
      .ExternalClass div {
        line-height: 100%;
      }
      .apple-link a {
        color: inherit !important;
        font-family: inherit !important;
        font-size: inherit !important;
        font-weight: inherit !important;
        line-height: inherit !important;
        text-decoration: none !important;
      }
    }
    </style>

    <!--[if gte mso 9]>
    <xml>
 <o:OfficeDocumentSettings>
  <o:AllowPNG/>
  <o:PixelsPerInch>96</o:PixelsPerInch>
 </o:OfficeDocumentSettings>
</xml>
<![endif]-->


  <body style="font-family: Helvetica, sans-serif; -webkit-font-smoothing: antialiased; font-size: 14px; line-height: 1.4; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%; background-color: ##f6f6f6; margin: 0; padding: 0;">
    <table border="0" cellpadding="0" cellspacing="0" class="body" style="border-collapse: separate; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: 100%; background-color: ##f6f6f6;" width="100%" bgcolor="##f6f6f6">
      <tr>
        <td style="font-family: Helvetica, sans-serif; font-size: 14px; vertical-align: top;" valign="top">&nbsp;</td>
        <td class="container" style="font-family: Helvetica, sans-serif; font-size: 14px; vertical-align: top; margin: 0 auto !important; max-width: 600px; padding: 0; padding-top: 24px; width: 600px;" width="600" valign="top">
		
          <div class="content" style="box-sizing: border-box; display: block; margin: 0 auto; max-width: 600px; padding: 0;">

            <!--- START CENTERED WHITE CONTAINER --->
            <span class="preheader" style="color: transparent; display: none; height: 0; max-height: 0; max-width: 0; opacity: 0; overflow: hidden; mso-hide: all; visibility: hidden; width: 0;">Process completed successfully.</span>

			
            <!--- START HEADER 
            <div class="header" style="margin-bottom: 24px; margin-top: 0; width: 100%;">
              <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: separate; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: 100%; min-width: 100%;" width="100%">
                <tr>
                  <td style="padding: 20px 15px 25px;"><img src="cid:logo" height="42" width="150"></td>
                </tr>
              </table>
            </div>
			--->

            <!--- END HEADER --->
            <table border="0" cellpadding="0" cellspacing="0" class="main" style="border-collapse: separate; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: 100%; background: ##ffffff; border-radius: 4px;" width="100%">

              <!--- START NOTIFICATION BANNER --->
              <tr>
                <td style="font-family: Helvetica, sans-serif; font-size: 14px; vertical-align: top;" valign="top">
                  <table border="0" cellpadding="0" cellspacing="0" class="alert alert-success" style="border-collapse: separate; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: 100%; min-width: 100%;" width="100%">
                    <tr>
                      <td align="center" style="font-family: Helvetica, sans-serif; vertical-align: top; font-size: 24px; border-radius: 4px 4px 0 0; color: ##ffffff; font-weight: 400; padding: 24px; text-align: center; background-color: ##1abc9c;" valign="top" bgcolor="##1abc9c">
                          <cfif Last.ActionStatus eq "2">
                                Process Completed With Errors
                              <cfelse>
                                Process Completed Successfully
                          </cfif>
                      </td>
                    </tr>
                  </table>
                </td>
              </tr>

              <!--- END NOTIFICATION BANNER --->
              
			  <!--- START MAIN CONTENT AREA --->
			  <tr>
                <td class="wrapper" style="font-family: Helvetica, sans-serif; font-size: 14px; vertical-align: top; box-sizing: border-box; padding: 24px;" valign="top">
                  <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: separate; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: 100%;" width="100%">
                    <tr>
                      <td style="font-family: Helvetica, sans-serif; font-size: 14px; vertical-align: top;" valign="top">
                        <p style="font-family: Helvetica, sans-serif; font-size: 18px; font-weight: normal; margin: 0; margin-bottom: 16px;">
                            Scheduled Task:<strong>&nbsp;#Template.scheduleName#</strong><br>
                            <strong>#template.schedulememo#</strong>
                        </p>
                          <p style="font-family: Helvetica, sans-serif; font-size: 14px; font-weight: normal; margin: 0; margin-bottom: 16px;color:##333333;">
                          <strong><u>Schedule</u></strong><br>
                              <strong>Interval:</strong> #Template.ScheduleInterval#<br>
                              <strong>Class:</strong> #Template.ScheduleClass#<br>
                              <strong>Started at:</strong> #Template.ScheduleStartTime#<br>
                              <br>
                              <strong><u>Process Success Information</u></strong><br>
                              <strong>Account:</strong> #Last.OfficerUserId#<br>
                              <strong>Application Server:</strong> #Template.ApplicationServer#<br>
                              <strong>Remote Address:</strong> #Last.NodeIP#<br>
                              <strong>Timestamp:</strong> #DateFormat(Last.ProcessEnd,CLIENT.DateFormatShow)# #TimeFormat(Last.ProcessEnd,"HH:MM:SS")#<br>
                          </p>
                      </td>
                    </tr>
                  </table>
                </td>
              </tr>

              <!--- END MAIN CONTENT AREA --->
              </table>

            <!--- START FOOTER --->
            <cf_MailDefaultFooter>

            <!--- END FOOTER --->
            
		<!--- END CENTERED WHITE CONTAINER --->
		</div>
        </td>
        <td style="font-family: Helvetica, sans-serif; font-size: 14px; vertical-align: top;" valign="top">&nbsp;</td>
      </tr>
    </table>
  </body>
 
		 	<!---					
			<cfmailparam file="#SESSION.root#/Images/prosis-logo-300.png" contentid="logo" disposition="inline"/>
			--->
            <cfmailparam file="#SESSION.root#/Images/prosis-logo-gray.png" contentid="logo-gray" disposition="inline"/>
																			  
		</cfmail>			
	</cfif>
</cfoutput>

