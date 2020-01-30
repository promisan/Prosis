
<cfparam name="Attributes.Class" 	        default="Memo">
<cfparam name="Attributes.DocumentDate" 	default="">
<cfparam name="Attributes.Reference"        default="">
<cfparam name="Attributes.To"	            default="">
<cfparam name="Attributes.From" 	        default="">
<cfparam name="Attributes.Subject"          default="">

<cfparam name="Attributes.Logo" 		    default="">
<cfparam name="Attributes.TitleLine1"       default="">
<cfparam name="Attributes.TitleLine2"       default="">
<cfparam name="Attributes.TitleLine3"       default="">
<cfparam name="Attributes.TitleLine4"       default="">
<cfparam name="Attributes.TitleLine5"       default="">

<cfparam name="Attributes.SignatureTitle"   default="">
<cfparam name="Attributes.SignatureLine1"   default="">
<cfparam name="Attributes.SignatureLine2"   default="">
<cfparam name="Attributes.SignatureLine3"   default="">
<cfparam name="Attributes.SignatureLine4"   default="">

<cfparam name="Attributes.SectionLine"      default="No">

<cfparam name="Attributes.Closign"          default="">
<cfparam name="Attributes.SignedBy"         default="">
<cfparam name="Attributes.SignatureLabel"   default="">
<cfparam name="Attributes.AdditionalDocs"   default="">

<cfif thisTag.ExecutionMode is 'start'>

	<html xmlns="http://www.w3.org/1999/xhtml">
	<html>
	
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />		
	
		<style type="text/css">
		body
		{
			border : 0 0;
			border-top : 0 none;
			margin : 0 0 0 0;
			margin-bottom : 0;
			margin-left : 0;
			margin-right : 0;
			margin-top : 0;
			padding : 0 0 0 0;
			padding-bottom : 0;
			padding-left : 0;
			padding-right : 0;
			padding-top : 0;
			
		}

		#tdata_letter
		{
			font-family:"Trebuchet MS", Arial, Helvetica, sans-serif;
			width:100%;
			border:0px solid #b0b0b0;
			padding:0px 0px 0px 0px;
		}

		#tdata_memo
		{
			font-family:"Trebuchet MS", Arial, Helvetica, sans-serif;
			width:100%;
			border:0px solid #b0b0b0;
			padding:0px 0px 0px 0px;
		}

		#tmain {
			font-family:"Verdana", Arial, Helvetica, sans-serif;
			border: 0px solid White;
			padding:0px 0px 0px 0px;
			align : justify;
		}

		td.serif{
			font-family:"Times New Roman", Courier, Garamond, serif;
			font-size : 22pt;
			font-weight:normal;
			align : justify;
		}

		td.serif_small{
			font-family:"Times New Roman", Courier, Garamond, serif;
			font-size : 7pt;
			font-weight:normal;
			align : justify;
		}

		#tdata_letter td {
			font-family:"Times New Roman", Courier, Garamond, serif;
			font-size : 10pt;
			align : justify;
		}


		td.memoheader {
			font-family:"Times New Roman", Courier, Garamond, serif;
			font-size : 10pt;
			align : justify;
		}


		div.content {
			align : justify;
		}


		td.continous
		{
			border-bottom: solid 1px #000000;
			padding: 2px 0 2px 0

		}

		td.square
		{
			border-bottom: solid 1px #000000;
			border-top: solid 1px #000000;
			border-left: solid 1px #000000;
			border-right: solid 1px #000000;
			padding: 0px 0 0px 0

		}

		td.dotted
		{
			border-bottom: 1px dashed #000;
			padding: 2px 0 2px 0

		}

		td.bold
		{
			font-family:arial, helvetica; 
			font-size:12px; 
			font-weight:bold;
		}

		td.small_bold
		{
			font-family:arial, helvetica; 
			font-size:10px; 
			font-weight:bold;
		}
		
		td.xsmall_bold
		{
			font-family:arial, helvetica; 
			font-size:9px; 
			font-weight:bold;
		}			
		
		td.underline
		{
			font-family:arial, helvetica;
			font-size:12px;
			font-weight:normal;
			text-decoration : underline;
		}

		td.bold_underline
		{
			font-family:arial, helvetica;
			font-size:12px;
			font-weight:bold;
			text-decoration : underline;
		}			
</style>
		
		
		</head>
		
		<body>

		<table width="99%" cellspacing="0" cellpadding="0" id="tmain">
		<cfif Attributes.TitleLine1 neq "" or
		  Attributes.Logo neq "" or
		  Attributes.TitleLine2 neq "" or 
		  Attributes.TitleLine3 neq "" or
		  Attributes.TitleLine4 neq "" or
		  Attributes.TitleLine5 neq "">		
		  <tr align="center" valign="top">
				<td colspan="3" height="60" width="100%">
				
					<table width="100%" cellspacing="0" cellpadding="0">

						<tr>
							<td valign="bottom" align="right" width="45%" class="serif">
								<cfoutput>#Attributes.TitleLine1#</cfoutput>
							</td>
							<td align="center" width="10%">
								<cfoutput>#Attributes.Logo#</cfoutput>
							</td>
							<td valign="bottom" align="left" width="45%" class="serif">
								<cfoutput>#Attributes.TitleLine2#</cfoutput>
							
							</td>
						</tr>
						
						<cfswitch expression="#Attributes.Class#">
						<cfcase value="Memo">
							<tr>
								<td align="right" width="45%" class="serif_small">
								<cfoutput>#Attributes.TitleLine3#</cfoutput>
								
								</td>
								<td align="center" width="10%">
								</td>
								<td align="left" width="45%" class="serif_small">
								<cfoutput>#Attributes.TitleLine4#</cfoutput>
								</td>
							</tr>				
						</cfcase>
						<cfcase value="Letter">
							<tr>
								<td colspan="3" align="center" class="serif_small">
								<cfoutput>#Attributes.TitleLine3#</cfoutput>
								
								</td>
							</tr>	
							<tr>
								<td colspan="3" align="center" class="serif_small">
								<cfoutput>#Attributes.TitleLine4#</cfoutput>
								
								</td>
							</tr>
							<cfif Attributes.TitleLine5 neq "">
							<tr>
								<td colspan="3" align="center" class="serif_small">
								<cfoutput>#Attributes.TitleLine5#</cfoutput>
								</td>
							</tr>
							</cfif>														
						</cfcase>
						<cfcase value="Note">
							<tr>
								<td colspan="3" align="center">
								<cfoutput>#Attributes.TitleLine3#</cfoutput>
								
								</td>
							</tr>	
							<tr>
								<td colspan="3" align="center">
								<cfoutput>#Attributes.TitleLine4#</cfoutput>
								</td>
							</tr>
							<cfif Attributes.TitleLine5 neq "">
							<tr>
								<td colspan="3" align="center">
								<cfoutput>#Attributes.TitleLine5#</cfoutput>
								</td>
							</tr>
							</cfif>														
						</cfcase>														
						</cfswitch>						

					</table>
				</td>
		  </tr>
		 </cfif>		
		  <tr>
			
			<td width="5%"></td>
		    <td width="80%" class="serif_small">
						
			<cfswitch expression="#Attributes.Class#">
		
				<cfcase value="Memo">
						<cfinclude template="Layouts/Memo.cfm">
				</cfcase>
				<cfcase value="Letter">
						<cfinclude template="Layouts/Letter.cfm">
				</cfcase>							
		
			</cfswitch>
			
			</td>
		  </tr>
		  
		  <tr>
		    <td width="5%"></td>
		    <td width="80%" class="serif_small">
			
			<!--- body content comes here to be loaded on the fly --->
						
<cfelse>

			<!--- end template --->

		    </td>
			<td width="5%"></td>
		  </tr>
		  
		 <tr>
			<td width="5%"></td>
			<td width="80%" class="serif_small">
			
		 <!---We should see if there is a signature block --->
		 <cfswitch expression="#Attributes.Class#">
		
			<cfcase value="Memo">
					<cfinclude template="Layouts/Signature_Memo.cfm">
			</cfcase>
			<cfcase value="Letter">
					<cfinclude template="Layouts/Signature_Letter.cfm">
			</cfcase>							
		
		</cfswitch>			
		
		<!----- we should print the botton of the page --->
		
		    </td>
			<td width="5%"></td>
		  </tr>
			
		</table>		
		
		</body>
		</html>
		
</cfif>  

