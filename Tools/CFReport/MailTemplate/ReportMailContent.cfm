<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<cf_tl id="Report Distribution" var="vTitle">
<cfset vPreHeader = "Report Distribution">

<cfoutput>
<!doctype html>
<html>
  <head>
    <meta name="viewport" content="width=device-width">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>#vTitle#</title>
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
    
  </head>
  <body style="font-family: Helvetica, sans-serif; -webkit-font-smoothing: antialiased; font-size: 14px; line-height: 1.4; -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%; background-color: ##f6f6f6; margin: 0; padding: 0;">
    <table border="0" cellpadding="0" cellspacing="0" class="body" style="border-collapse: separate; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: 100%; background-color: ##f6f6f6;" width="100%" bgcolor="##f6f6f6">
      <tr>
        <td style="font-family: Helvetica, sans-serif; font-size: 14px; vertical-align: top;" valign="top">&nbsp;</td>
        <td class="container" style="font-family: Helvetica, sans-serif; font-size: 14px; vertical-align: top; margin: 0 auto !important; max-width: 600px; padding: 0; padding-top: 24px; width: 600px;" width="600" valign="top">
          <div class="content" style="box-sizing: border-box; display: block; margin: 0 auto; max-width: 600px; padding: 0;">

            <!-- START CENTERED WHITE CONTAINER -->
            <span class="preheader" style="color: transparent; display: none; height: 0; max-height: 0; max-width: 0; opacity: 0; overflow: hidden; mso-hide: all; visibility: hidden; width: 0;">#vPreHeader#</span>

            <table border="0" cellpadding="0" cellspacing="0" class="main" style="border-collapse: separate; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: 100%; background: ##fff; border-radius: 4px;" width="100%">

              <!-- START NOTIFICATION BANNER -->
			  <!---
              <tr>
                <td style="font-family: Helvetica, sans-serif; font-size: 14px; vertical-align: top;" valign="top">
                  <table border="0" cellpadding="0" cellspacing="0" class="alert alert-danger" style="background: ##f6f6f6; border-collapse: separate; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: 100%; min-width: 100%;" width="100%">
                    <tr>
                      <td style="padding: 20px 15px 25px;"><img src="cid:logo" height="42" width="150"></td>
                    </tr>
                  </table>
                </td>
              </tr>
			  --->

							<tr>
                <td style="font-family: Helvetica, sans-serif; font-size: 14px; vertical-align: top;" valign="top">
                  <table border="0" cellpadding="0" cellspacing="0" class="alert alert-success" style="border-collapse: separate; mso-table-lspace: 0pt; mso-table-rspace: 0pt; width: 100%; min-width: 100%;" width="100%">
                    <tr>
                      <td align="center" style="font-family: Helvetica, sans-serif; vertical-align: top; font-size: 24px; border-radius: 4px 4px 0 0; color: ##ffffff; font-weight: 400; padding: 24px; text-align: center; background-color: ##1abc9c;" valign="top" bgcolor="##1abc9c">
                          #SESSION.welcome#: <strong>Report Notification</strong>
                      </td>
                    </tr>
                  </table>
                </td>
              </tr>

              <!-- END NOTIFICATION BANNER -->
              
							<!-- START MAIN CONTENT AREA -->
							<tr>
                <td class="wrapper" style="font-family: Helvetica, sans-serif; font-size: 14px; vertical-align: top; box-sizing: border-box; padding: 24px;" valign="top">

                  <p style="font-family: Helvetica, sans-serif; font-size: 18px; font-weight: normal; margin: 0; margin-bottom: 16px;">
											<strong>#Layout.Owner# Report Agent</strong>
									</p>
									<p style="font-family: Helvetica, sans-serif; font-size: 14px; font-weight: normal; margin: 0; margin-bottom: 16px;color:##333333;">
									<strong><u>Subscriber</u></strong><br>
											<strong>Account:</strong> #Param.OfficerUserId#<br>
											<strong>Name:</strong> #Param.OfficerFirstName# #Param.OfficerLastName#<br>
											<strong>Period:</strong> #DateFormat(Param.DateEffective,CLIENT.DateFormatShow)# - #DateFormat(Param.DateExpiration,CLIENT.DateFormatShow)#<br>
											<br>
											<strong><u>Report Information</u></strong><br>
											<strong>Name:</strong> #User.DistributionSubject#<br>
											<strong>Selected Layout:</strong> #Layout.LayoutName#<br>
											<strong>Send to:</strong> #User.DistributioneMail#<br>
											<cfif User.DistributioneMailCC neq ""><strong>CC to:</strong> #User.DistributioneMailCC#<br></cfif>
											<strong>Server Id:</strong> #CGI.HTTP_HOST#<br>
											<strong>Mode:</strong> <cfif User.DistributionMode neq "Hyperlink">Attachment<cfelse>Hyperlink</cfif><br>
											<strong>Format:</strong> <cfif Layout.TemplateReport neq "Excel">#User.Fileformat#<cfelse>Excel</cfif><br>
											<cfif Param.DistributionMode neq "Attachment" or (Layout.LayoutClass eq "View" and Report.EnableAttachment eq "0")>
												<strong>Hyperlink:</strong> 
												<a href="#rptserver#/Report.cfm?id=#URL.reportId#" target="_blank">
													<b><u>Press here to open your report</u></b>
												</a>
												<br>
												<strong>Or Paste this link in browser:</strong> #rptserver#/Report.cfm?id=#URL.reportId#<br>
											</cfif>

											<cftry>  
																		
													<cfquery name="Detail" 
															datasource="AppsSystem">
														SELECT   C.*, U.DistributionMode, CR.CriteriaDescription AS CriteriaDescription
																	FROM     UserReportCriteria C INNER JOIN
																					UserReport U ON C.ReportId = U.ReportId INNER JOIN
																					Ref_ReportControlCriteria CR ON C.CriteriaName = CR.CriteriaName INNER JOIN
																					Ref_ReportControlLayout L ON U.LayoutId = L.LayoutId AND CR.ControlId = L.ControlId
														WHERE    U.ReportId = '#URL.ReportId#' 
														AND      CR.Operational = 1
														ORDER BY CriteriaOrder
													</cfquery>
																						
													<cfcatch>
													
														<cfset URL.ReportId = "#attributes.ReportId#">
														
														<cfquery name="Detail" 
																datasource="AppsSystem">
															SELECT   C.*, U.DistributionMode, CR.CriteriaDescription AS CriteriaDescription
																		FROM     UserReportCriteria C INNER JOIN
																						UserReport U ON C.ReportId = U.ReportId INNER JOIN
																						Ref_ReportControlCriteria CR ON C.CriteriaName = CR.CriteriaName INNER JOIN
																						Ref_ReportControlLayout L ON U.LayoutId = L.LayoutId AND CR.ControlId = L.ControlId
															WHERE    U.ReportId = '#attributes.ReportId#'
															AND      CR.Operational = 1
															ORDER BY CriteriaOrder
														</cfquery>
													
													</cfcatch>
													
											</cftry>

											<br>
											<strong><u>Applied content filtering criteria</u></strong><br>
											<cfloop query="Detail">
												<cfif criteriavalue neq "">
													<strong>#CriteriaDescription#:</strong> #CriteriaValue#<br>
												</cfif>
											</cfloop>

									</p>
			
                </td>
              </tr>

              <!-- END MAIN CONTENT AREA -->
              </table>

            <!-- START FOOTER -->
            <cf_MailDefaultFooter>
            <!-- END FOOTER -->
            
					</div>
        </td>
        <td style="font-family: Helvetica, sans-serif; font-size: 14px; vertical-align: top;" valign="top">&nbsp;</td>
      </tr>
    </table>
  </body>
</html>
</cfoutput>