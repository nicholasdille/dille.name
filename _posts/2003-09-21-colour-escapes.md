---
id: 562
title: Colour Escapes
date: 2003-09-21T07:51:07+00:00
author: Nicholas Dille
layout: post
permalink: /blog/2003/09/21/colour-escapes/
categories:
  - Nerd of the Old Days
tags:
  - Bash
  - Linux
---
Colour escape sequences are useful for designing text user interfaces (TUI).

<!--more-->

  * _Layout of an colour escape sequence:_ <pre class="listing">echo -e "\033[&lt;parameter&gt;&lt;action&gt;"</pre>
    
    <code class="command">\033</code> enters escape mode and <code class="command">[</code> is called the command sequence introduction.
    
    Several parameters-action pairs can be specified in a single escape sequence by separating them using semicolons.</li> </ul> </ul> 
    
      * _Actions:_
  
        <table summary="This table contains descriptions of the action that can be used in a colour escape sequence">
          <tr>
            <th id="action">
              Action
            </th>
            
            <th id="action_description">
              Description
            </th>
          </tr>
          
          <tr>
            <td headers="action">
              <code class="command">h</code>
            </td>
            
            <td headers="action_description">
              Set ansi mode (no parameters)
            </td>
          </tr>
          
          <tr>
            <td headers="action">
              <code class="command">l</code>
            </td>
            
            <td headers="action_description">
              Clear ansi mode (no parameters)
            </td>
          </tr>
          
          <tr>
            <td headers="action">
              <code class="command">m</code>
            </td>
            
            <td headers="action_description">
              Colours
            </td>
          </tr>
          
          <tr>
            <td headers="action">
              <code class="command">q</code>
            </td>
            
            <td headers="action_description">
              Controls keyboard leds
            </td>
          </tr>
          
          <tr>
            <td headers="action">
              <code class="command">s</code>
            </td>
            
            <td headers="action_description">
              Stores position and attributes
            </td>
          </tr>
          
          <tr>
            <td headers="action">
              <code class="command">u</code>
            </td>
            
            <td headers="action_description">
              Restores position and attributes
            </td>
          </tr>
        </table>
    
      * _Parameters for action <code class="command">m</code>:_
  
        <table summary="This table describes parameters for the action m">
          <tr>
            <th id="parameter_m">
              Parameter
            </th>
            
            <th id="m_description">
              Description
            </th>
          </tr>
          
          <tr>
            <td headers="parameter_m">
            </td>
            
            <td headers="m_description">
              Set defaults
            </td>
          </tr>
          
          <tr>
            <td headers="parameter_m">
              1
            </td>
            
            <td headers="m_description">
              Bold
            </td>
          </tr>
          
          <tr>
            <td headers="parameter_m">
              2
            </td>
            
            <td headers="m_description">
              Dim
            </td>
          </tr>
          
          <tr>
            <td headers="parameter_m">
              5
            </td>
            
            <td headers="m_description">
              Blink
            </td>
          </tr>
          
          <tr>
            <td headers="parameter_m">
              7
            </td>
            
            <td headers="m_description">
              Inverse video
            </td>
          </tr>
          
          <tr>
            <td headers="parameter_m">
              11
            </td>
            
            <td headers="m_description">
              Display special control characters graphically (alt + numpad)
            </td>
          </tr>
          
          <tr>
            <td headers="parameter_m">
              25
            </td>
            
            <td headers="m_description">
              No blink
            </td>
          </tr>
          
          <tr>
            <td headers="parameter_m">
              27
            </td>
            
            <td headers="m_description">
              No inverse video
            </td>
          </tr>
          
          <tr>
            <td headers="parameter_m">
              30
            </td>
            
            <td headers="m_description">
              Foreground colours is black
            </td>
          </tr>
          
          <tr>
            <td headers="parameter_m">
              31
            </td>
            
            <td headers="m_description">
              Foreground colours is red
            </td>
          </tr>
          
          <tr>
            <td headers="parameter_m">
              32
            </td>
            
            <td headers="m_description">
              Foreground colours is green
            </td>
          </tr>
          
          <tr>
            <td headers="parameter_m">
              33
            </td>
            
            <td headers="m_description">
              Foreground colours is yellow
            </td>
          </tr>
          
          <tr>
            <td headers="parameter_m">
              34
            </td>
            
            <td headers="m_description">
              Foreground colours is blue
            </td>
          </tr>
          
          <tr>
            <td headers="parameter_m">
              35
            </td>
            
            <td headers="m_description">
              Foreground colours is magenta
            </td>
          </tr>
          
          <tr>
            <td headers="parameter_m">
              36
            </td>
            
            <td headers="m_description">
              Foreground colours is cyan
            </td>
          </tr>
          
          <tr>
            <td headers="parameter_m">
              37
            </td>
            
            <td headers="m_description">
              Foreground colours is white
            </td>
          </tr>
          
          <tr>
            <td headers="parameter_m">
              40
            </td>
            
            <td headers="m_description">
              Background colours is black
            </td>
          </tr>
          
          <tr>
            <td headers="parameter_m">
              41
            </td>
            
            <td headers="m_description">
              Background colours is red
            </td>
          </tr>
          
          <tr>
            <td headers="parameter_m">
              42
            </td>
            
            <td headers="m_description">
              Background colours is green
            </td>
          </tr>
          
          <tr>
            <td headers="parameter_m">
              43
            </td>
            
            <td headers="m_description">
              Background colours is yellow
            </td>
          </tr>
          
          <tr>
            <td headers="parameter_m">
              44
            </td>
            
            <td headers="m_description">
              Background colours is blue
            </td>
          </tr>
          
          <tr>
            <td headers="parameter_m">
              45
            </td>
            
            <td headers="m_description">
              Background colours is magenta
            </td>
          </tr>
          
          <tr>
            <td headers="parameter_m">
              46
            </td>
            
            <td headers="m_description">
              Background colours is cyan
            </td>
          </tr>
          
          <tr>
            <td headers="parameter_m">
              47
            </td>
            
            <td headers="m_description">
              Background colours is white
            </td>
          </tr>
        </table>
    
      * _Parameters for action <code class="command">q</code>:_
  
        <table summary="This table describes parameters for the action q">
          <tr>
            <th id="parameter_q">
              Parameter
            </th>
            
            <th id="q_description">
              Description
            </th>
          </tr>
          
          <tr>
            <td headers="parameter_q">
            </td>
            
            <td headers="q_description">
              LEDs off
            </td>
          </tr>
          
          <tr>
            <td headers="parameter_q">
              1
            </td>
            
            <td headers="q_description">
              Scroll lock on, others off
            </td>
          </tr>
          
          <tr>
            <td headers="parameter_q">
              2
            </td>
            
            <td headers="q_description">
              Num lock on
            </td>
          </tr>
          
          <tr>
            <td headers="parameter_q">
              3
            </td>
            
            <td headers="q_description">
              Caps lock on
            </td>
          </tr>
        </table>
