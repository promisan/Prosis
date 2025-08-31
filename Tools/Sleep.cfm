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
<!--- sleep custom tag
- causes CF to halt your program for specified number of seconds (does NOT halt the entire server)
- expected attribute: sleep (specified in seconds)
- example: <cf_sleep seconds="n"> 

- by Charlie Arehart, dev@email
--->

<cfparam name="attributes.seconds" default="2">
<cfobject type="JAVA" name="obj" class="java.lang.Thread" action="CREATE">

<cfset obj.sleep(#evaluate(attributes.seconds*10)#)>
