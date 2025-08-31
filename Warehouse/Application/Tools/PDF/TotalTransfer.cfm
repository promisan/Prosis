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
            <assist role="TR"/>
            <field name="SubTotal" y="57.15mm" x="133.35mm" w="200" h="6.35mm" access="readOnly" colSpan="11">
               <ui>
                  <numericEdit>
                     <border presence="hidden">
                        <?templateDesigner StyleID aped0?></border>
                     <margin/>
                  </numericEdit>
               </ui>
               <font size="9pt" typeface="Myriad Pro" weight="bold"/>
               <margin topInset="0mm" bottomInset="0mm" leftInset="0mm" rightInset="1.9812mm"/>
               <para vAlign="middle" hAlign="right"/>
			   <cfset vReserved = vXSmall+ vSmall+vSmall+vMedium+vLarge+vMedium+vLarge+vMedium+vLarge+vMedium>
               <caption reserve="#vReserved#mm">
                  <font size="9pt" typeface="Myriad Pro" weight="bold" baselineShift="0pt"/>
                  <para vAlign="middle" hAlign="right" marginRight="3.6pt" marginLeft="0pt"/>
                  <value>
                     <text>Total     </text>
                  </value>
               </caption>
               <border>
                  <edge/>
                  <corner thickness="0.006in"/>
                  <corner/>
                  <corner>
                     <color value="192,192,192"/>
                  </corner>
                  <corner/>
                  <edge/>
                  <edge>
                     <color value="192,192,192"/>
                  </edge>
                  <edge/>
               </border>
               <format>
                  <picture>z,zzz,zz9.99</picture>
               </format>
               <calculate>
			   <cfoutput>
                  <script>
				  	
				  	Sum(
					<cfset i=0>
					<cfloop condition = "i lt #vTotalRows#"> 
						<cfset i = i + 1>
						<cfif i eq 1>
							xfa.form.form1.Transaction_Logsheet.Table1.Row#i#.Qty.rawValue
						<cfelse>	
							,xfa.form.form1.Transaction_Logsheet.Table1.Row#i#.Qty.rawValue
						</cfif>
					</cfloop>	
					)
					
				   </script>
				  </cfoutput> 
               </calculate>

            </field>
