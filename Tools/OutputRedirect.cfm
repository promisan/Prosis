<!--
    Copyright © 2025 Promisan B.V.

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
<!---
 Tag:     <CF_OutputRedirect> ... </CF_OutputRedirect>
 File:    OutputRedirect.cfm
 Author:  Ben Forta - dev@email
 Version: 1.0
 Date:    7/1/2000
 
 Description:
  <CF_OutputRedirect> is used to redirect
  dynamically generated content to an
  e-mail message, a file, or a variable.
  This is an invaluable debugging tool,
  and also is for use whenever redirection
  is needed. This tag must be used with
  it's corresponding end tag, which means
  it can only be used with CF4 or later.
 
 Syntax:
  To redirect to e-mail:
  <CF_OutputRedirect OUTPUT="EMAIL"
                     FROM="address"
					 TO="address"
					 SUBJECT="subject">
  ...
  </CF_OutputRedirect>
 
  To redirect to a file:
  <CF_OutputRedirect OUTPUT="FILE"
					 FILE="path">
  ...
  </CF_OutputRedirect>

  To redirect to a variable:
  <CF_OutputRedirect OUTPUT="variable"
					 VARIABLE="name">
  ...
  </CF_OutputRedirect>
  
 Attributes:
  FILE     - Required if OUTPUT=FILE, fully
             qualified name of file to be written.
  FROM     - Required if OUTPUT=EMAIL, valid sender
             e-mail address.
  OUTPUT   - Required. Redirection type, must
             be EMAIL, FILE, or VARIABLE.
  SUBJECT  - Required if OUTPUT=EMAIL, e-mail
             message subject.
  TO       - Required if OUTPUT=EMAIL, valid
             destination e-mail address.
  VARIABLE - Required if OUTPUT=VARIABLE, valid
             variable name to be created in CALLER
			 scope (do not include CALLER prefix).
--->


<!--- Process in END mode --->
<CFIF ThisTag.ExecutionMode IS "End">

 <!--- Start try block --->
 <CFTRY>
 
  <!--- Initialize parameters --->
  <CFPARAM NAME="ATTRIBUTES.output" DEFAULT="">
  <CFPARAM NAME="ATTRIBUTES.from" DEFAULT="">
  <CFPARAM NAME="ATTRIBUTES.to" DEFAULT="">
  <CFPARAM NAME="ATTRIBUTES.subject" DEFAULT="">
  <CFPARAM NAME="ATTRIBUTES.file" DEFAULT="">
  <CFPARAM NAME="ATTRIBUTES.variable" DEFAULT="">

  <!--- Check the selected output --->
  <CFSWITCH EXPRESSION="#ATTRIBUTES.output#">

   <!--- Redirect to e-mail message --->
   <CFCASE VALUE="email">
   
    <!--- Verify required attributes --->
	<CFIF ATTRIBUTES.from IS ""><CFTHROW MESSAGE="Invalid FROM attribute" DETAIL="FROM is required if OUTPUT=EMAIL."></CFIF>
	<CFIF ATTRIBUTES.to IS ""><CFTHROW MESSAGE="Invalid TO attribute" DETAIL="TO is required if OUTPUT=EMAIL."></CFIF>
	<CFIF ATTRIBUTES.subject IS ""><CFTHROW MESSAGE="Invalid SUBJECT attribute" DETAIL="SUBJECT is required if OUTPUT=EMAIL."></CFIF>
	
	<!--- Send mail --->
    <CFMAIL FROM="#ATTRIBUTES.from#" TO="#ATTRIBUTES.to#" SUBJECT="#ATTRIBUTES.subject#">#ThisTag.GeneratedContent#</CFMAIL>
	
   </CFCASE>

   
   <!--- Redirect to file --->
   <CFCASE VALUE="file">
   
    <!--- Verify required attributes --->
	<CFIF ATTRIBUTES.file IS ""><CFTHROW MESSAGE="Invalid FILE attribute" DETAIL="FILE is required if OUTPUT=FILE."></CFIF>
	
	<!--- Write to file --->
    <CFFILE ACTION="WRITE" FILE="#ATTRIBUTES.file#" OUTPUT="#ThisTag.GeneratedContent#">
	
   </CFCASE>

 
   <!--- Redirect to a variable --->
   <CFCASE VALUE="variable">
   
    <!--- Verify required attributes --->
	<CFIF ATTRIBUTES.variable IS ""><CFTHROW MESSAGE="Invalid VARIABLE attribute" DETAIL="VARIABLE is required if OUTPUT=VARIABLE."></CFIF>
	
	<!--- Write variable --->
    <CFSET "CALLER.#ATTRIBUTES.variable#"=ThisTag.GeneratedContent>
	
   </CFCASE>
   
   
   <!--- Any other value is an error --->
   <CFDEFAULTCASE>
   
    <!--- Throw error --->
    <CFTHROW MESSAGE="Invalid OUTPUT attribute" DETAIL="OUTPUT may not be left empty, and must be EMAIL, FILE, or VARIABLE.">
	
   </CFDEFAULTCASE>

  </CFSWITCH>

  <!--- Clear content --->
  <CFSET ThisTag.GeneratedContent="">
  
  <!--- Catch any errors --->
  <CFCATCH TYPE="Any">

   <!--- Clear content --->
   <CFSET ThisTag.GeneratedContent="">
  
   <!--- Display error message --->
   <CFOUTPUT>
    <TABLE BORDER="1"><TR><TD>
    <H1>&lt;CF_OutputRedirect&gt;</H1>
	<H2>#CFCATCH.Message#</H2>
	#CFCATCH.Detail#
	</TD></TR></TABLE>
   </CFOUTPUT>
  </CFCATCH>

 <!--- End try block --->
 </CFTRY>

</CFIF>

