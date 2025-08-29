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
  <CFFUNCTION name="UtilizationGraph" returntype="void" output="Yes">  	
  <CFARGUMENT name="current" type="numeric" required="Yes">  	
  <CFARGUMENT name="total" type="numeric" required="Yes">  
  	<CFARGUMENT name="scaleto" type="numeric" required="No" default="100">  	
	<CFARGUMENT name="format" type="string" required="No" default="999999999.99">  
		<CFARGUMENT name="showfrom" type="boolean" required="No" default="yes">  	
		<CFPARAM name="REQUEST.cfcimgpath" default="images">  
			<CFIF ARGUMENTS.total>  		<CFSILENT><CFSET k=(ARGUMENTS.scaleto/ARGUMENTS.total)></CFSILENT>  	
				<TABLE cellspacing="0" border="0">  		
				<TR><TD><IMG src="#REQUEST.cfcimgpath#/appstyle/horbar2.gif" width="#int(evaluate(ARGUMENTS.current*k))#" height="12" border="0" 
				alt="#ARGUMENTS.current#%" 
				title="#ARGUMENTS.current#%"><IMG src="#REQUEST.cfcimgpath#/appstyle/horbar1.gif" width="#int(evaluate('(ARGUMENTS.total-ARGUMENTS.current)*k'))#" 
				height="12" border="0"></TD>  	
					<TD>                  <CFIF ARGUMENTS.format is "$">  			#dollarformat(ARGUMENTS.current)#<CFIF showfrom> from #dollarformat(ARGUMENTS.total)#      
				  </CFIF>                  <CFELSEIF ARGUMENTS.format is "%">  			#int(ARGUMENTS.current)#%                 
				   <CFELSE>  			#trim(numberformat(ARGUMENTS.current,"#ARGUMENTS.format#"))#
				   <CFIF showfrom> from #ARGUMENTS.total#</CFIF>                  </CFIF>                  </TD></TR>                 
				    </TABLE
