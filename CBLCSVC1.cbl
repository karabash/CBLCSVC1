
Comma Delimited File
Create a CSV File with COBOL	
 	Table of Contents	 v-16.01.01 - cblcsv01.htm 
 	Introduction
 	Programming Objectives
 	Programming Input and Output
 	Programming Requirements
 	Programming Overview
 	CMD for Batch Job
 	The COBOL Programs
 	The COBOL I/O Program
 	The COBOL Convert Routine
 	Record Layout, Fixed-Field Length
 	Summary
 	Software Agreement and Disclaimer
 	Downloads and Links
 	Current Server or Internet Access
 	Internet Access Required
 	Glossary of Terms
 	Comments or Feedback
 	Company Overview
The SimoTime Home Page 
Table of ContentsPrevious SectionNext SectionIntroduction
This suite of sample programs describes how to read a column oriented file of fixed length records and fixed length fields and create a comma-delimited file (filename.CSV, Comma-Separated-Value) of variable length fields with the leading and trailing spaces removed from each of the fields. If a field (or data string) contains a delimiter character then enclose the field in double quotes. The program may be adjusted to create a delimited file using a tab, semicolon or other character as the delimiter.

We have made a significant effort to ensure the documents and software technologies are correct and accurate. We reserve the right to make changes without notice at any time. The function delivered in this version is based upon the enhancement requests from a specific group of users. The intent is to provide changes as the need arises and in a timeframe that is dependent upon the availability of resources.

Copyright © 1987-2022
SimoTime Technologies and Services
All Rights Reserved

Table of ContentsPrevious SectionNext SectionProgramming Objectives
This example illustrates the following functions.

Item	Description
1	Demonstrate how to read a sequential file (or a Line Sequential file) and create a comma-delimited file using Micro Focus COBOL (Net Express was used for the testing).
2	Demonstrate how to remove leading spaces from each field.
3	Demonstrate how to remove trailing spaces from each field.
4	Demonstrate how to enclose a data string that contains a delimiter character in double quotes.
5	Describe how to scan the fields to remove the delimiter characters from the data string.
6	Demonstrate how to omit blank records from the output file.
7	Provide an example of a Window's CMD file to run the job on Windows using Micro Focus Net Express.
  A List of Functions Provided in this Sample Suite of Program Members
Table of ContentsPrevious SectionNext SectionProgramming Input and Output
The following is an example of a file that contains records with predefined, fixed-length fields. This file will be used to create a Comma Delimited file (filename.CSV).The customer number is in positions 1 through 6. Notice that customer numbers 002200, 002300 and 999999 contain examples of fields with leading spaces and fields that contain a comma in the data string. All the records have trailing spaces in the fields.

The following is the record layout for COBOL.

      *****************************************************************
      *               CUSTTXB1.CPY - a COBOL Copy File                *
      *        A Customer Text File used by CSV Demo programs.        *
      *         Copyright (C) 1987-2019 SimoTime Technologies         *
      *                     All Rights Reserved                       *
      *              Provided by SimoTime Technologies                *
      *        Our e-mail address is: helpdesk@simotime.com           *
      *     Also, visit our Web Site at http://www.simotime.com       *
      *****************************************************************
      *    The record length is 512 bytes.
      *
      *    Column  Field Name               Size
      *       -    -----------------------   --
      *       A    CUSTTEXT-KEY              12
      *       B    CUSTTEXT-STATUS           01
      *       C    CUSTTEXT-LAST-NAME        28
      *       D    CUSTTEXT-FIRST-NAME       20
      *       E    CUSTTEXT-STREET-ADDR-01   48
      *       F    CUSTTEXT-STREET-ADDR-02   48
      *       G    CUSTTEXT-CITY             16
      *       H    CUSTTEXT-STATE            02
      *       I    CUSTTEXT-POSTAL-CODE      12
      *       -    -----------------------   --
      *
       01  CUSTTEXT-RECORD.
           05  CUSTTEXT-KEY            PIC 9(12).
           05  CUSTTEXT-STATUS         PIC X.
           05  CUSTTEXT-LAST-NAME      PIC X(28).
           05  CUSTTEXT-FIRST-NAME     PIC X(20).
           05  CUSTTEXT-STREET-ADDR-01 PIC X(48).
           05  CUSTTEXT-STREET-ADDR-02 PIC X(48).
           05  CUSTTEXT-CITY           PIC X(16).
           05  CUSTTEXT-STATE          PIC X(2).
           05  CUSTTEXT-POSTAL-CODE    PIC X(12).
           05  FILLER                  PIC X(325).
      *
      ***  CUSTTXB1 - End-of-Copy File - - - - - - - - - - - CUSTTXB1 *
      *****************************************************************
      *

The following is the column-oriented, LINE SEQUENTIAL (ASCII/Text) file that was used for testing the programs.

000000000100 Anderson                    Adrian              1113 Peachtree Plaza, Suite 111                                                                 Atlanta         GA26101
000000000200 Brown                       Billie              224 Baker Boulevard                                                                             Baltimore       MD35702
000000000300 Carson                      Cameron             336 Crenshaw Blvd.                                                                              Cupertino       CA96154
000000000400 Davidson                    Dion                448 Main Street                                                                                 Wilmington      DE27323
000000000500 Everest                     Evan                55 5TH Avenue                                                                                   New York        NY10341
000000000600 Franklin                    Francis             6612 66TH Avenue                                                                                Bedrock         NY11903
000000000700 Garfunkel                   Gwen                777 77TH Street                                                                                 New York        NY16539
000000000800 Harrison                    Hilary              888 88TH Street                                                                                 Pocatello       ID79684
000000000900 Isley                       Isabel              999 99TH Avenue                                                                                 Indianapolis    IN38762
000000001000 Johnson                     Jamie               1010 Paradise Drive                                                                             Larkspur        CA90504
000000001100 Kemper                      Kelly               1111 Oak Circle                                                                                 Kansas City     KS55651
000000001200 Lemond                      Lesley              1212 Lockwood Road                                                                              Mohave Desert   AZ80303
000000001300 Mitchell                    Marlow              1313 Miller Creek Road                                                                          Anywhere        TX77123
000000001400 Newman                      Noel                1414 Park Avenue                                                                                Santa Monica    CA90210
000000001500 Osborn                      Owen                1515 Center Stage                                                                               Rolling Rock    PA36613
000000001600 Powell                      Pierce              PO Box 1616                                                                                     Ventura         CA97712
000000001700 Quigley                     Quincy              1717 Farm Hill Road                                                                             Oshkosh         WI43389
000000001800 Ripley                      Ray                 1818 Alien Lane                                                                                 Wayout          KS55405
000000001900 Smith                       Sammy               1919 Carnoustie Drive                                                                           Novato          CA94919
000000002000 Tucker                      Taylor              2020 Sanger Lane                                                                                St. Paul        MN43998
000000002100 Underwood                   Ulysses             2121 Wall Street                                                                                New York        NY17623
000000002200 Van Etten                   Valerie                 2222 Vine Street, #22                                                                       Hollywood       CA98775
000000002300 Wilson                      Wiley               2323 Main Street, #23                                                                             Boston        MA1472
000000002400 Xray                        Xavier              2424 24TH Street                                                                                Nashville       TN44190
000000002500 Young                       Yanni               2525 Yonge Street                                                                               Toronto         ON6B74A6
000000002600 Zenith                      Zebulon             2626 26TH Street                                                                                Dallas          TX71922
000000123456 Doe                         John                123 Main Street                                                                                 Anywhere        OR88156
000000999999 Smith                                              99 E Street                                                                                   San Rafael     CA94901
The following is an example of a Comma Delimited file that was created from reading the preceding Sequential (or LINE Sequential) file that contains records with predefined, fixed fields. This file was created by a COBOL program running on a PC with Micro Focus COBOL (Net Express, version 4.0).

100,,Anderson,Adrian,"1113 Peachtree Plaza, Suite 111",,Atlanta,GA,26101
200,,Brown,Billie,224 Baker Boulevard,,Baltimore,MD,35702
300,,Carson,Cameron,336 Crenshaw Blvd.,,Cupertino,CA,96154
400,,Davidson,Dion,448 Main Street,,Wilmington,DE,27323
500,,Everest,Evan,55 5TH Avenue,,New York,NY,10341
600,,Franklin,Francis,6612 66TH Avenue,,Bedrock,NY,11903
700,,Garfunkel,Gwen,777 77TH Street,,New York,NY,16539
800,,Harrison,Hilary,888 88TH Street,,Pocatello,ID,79684
900,,Isley,Isabel,999 99TH Avenue,,Indianapolis,IN,38762
1000,,Johnson,Jamie,1010 Paradise Drive,,Larkspur,CA,90504
1100,,Kemper,Kelly,1111 Oak Circle,,Kansas City,KS,55651
1200,,Lemond,Lesley,1212 Lockwood Road,,Mohave Desert,AZ,80303
1300,,Mitchell,Marlow,1313 Miller Creek Road,,Anywhere,TX,77123
1400,,Newman,Noel,1414 Park Avenue,,Santa Monica,CA,90210
1500,,Osborn,Owen,1515 Center Stage,,Rolling Rock,PA,36613
1600,,Powell,Pierce,PO Box 1616,,Ventura,CA,97712
1700,,Quigley,Quincy,1717 Farm Hill Road,,Oshkosh,WI,43389
1800,,Ripley,Ray,1818 Alien Lane,,Wayout,KS,55405
1900,,Smith,Sammy,1919 Carnoustie Drive,,Novato,CA,94919
2000,,Tucker,Taylor,2020 Sanger Lane,,St. Paul,MN,43998
2100,,Underwood,Ulysses,2121 Wall Street,,New York,NY,17623
2200,,Van Etten,Valerie,"    2222 Vine Street, #22",,Hollywood,CA,98775
2300,,Wilson,Wiley,"2323 Main Street, #23",,  Boston,MA,1472
2400,,Xray,Xavier,2424 24TH Street,,Nashville,TN,44190
2500,,Young,Yanni,2525 Yonge Street,,Toronto,ON,6B74A6
2600,,Zenith,Zebulon,2626 26TH Street,,Dallas,TX,71922
123456,,Doe,John,123 Main Street,,Anywhere,OR,88156
999999,,Smith,,   99 E Street,, San Rafael,CA,94901
Table of ContentsPrevious SectionNext SectionProgramming Requirements
This suite of samples programs will run on the following platforms.

Item	Description
1	Executes on Windows/XP, Windows/7 and Windows/Server using Micro Focus Net Express and the CMD file provided.
2	May be ported to run on the Linux and UNIX platforms supported by Micro Focus COBOL.
  Possible Platforms to Execute this Suite of Sample Programs
Table of ContentsPrevious SectionNext SectionProgramming Overview
The main program (CBLCSVC1) will read a Sequential file (TXTGETD1) and produce a 512-byte, variable record length Comma-delimited sequential file (CSVPUTD1). The contents of this file will be variable length fields separated by a comma. The leading and trailing spaces will be removed from each field. Embedded spaces will remain. The source code for the CMD file, the JCL member and the COBOL programs is provided and may be modified to fit your environment.

The following is a flowchart of the job for executing the program to create a Comma Delimited file from a Sequential file of fixed-length fields.

 	 	 	 	 	 	 	
CBLCSVE1
cmd
Start the Job
 		 
CUSTLFFL
LSEQ
Fixed-Field
 
 
CBLCSVC1
cbl
 		 
 		 
CUSTLCSV
LSEQ
Comma-Separated
Read a Line Sequential file and create a comma-delimited file, Note-1
 		 
 		 
 		 
 		 
 		 
CBLCSVR1
cbl
Do the record content conversion, FFL to CSV
 		 
EOJ
This is End-of-Job.
 							
Note-1: LSEQ = Line Sequential File, Record Format may be Comma-Separated-Value or Fixed-Field-Length
Create a Comma Delimited file from a Sequential file of fixed-length fields
Color Associations: The  light-green  boxes are unique to SIMOTIME Technologies using an IBM Mainframe System or Micro Focus Enterprise Developer. The  light-red  boxes are unique to the SIMOTIME Technologies using a Linux, UNIX or Windows System and COBOL Technologies such as Micro Focus. The  light-yellow  boxes are SIMOTIME Technologies, Third-party Technologies, decision points or program transitions in the processing logic or program generations. The  light-blue  boxes identify the input/output data structures such as Documents, Spreadsheets, Data Files, VSAM Data Sets, Partitioned Data Set Members (PDSM's) or Relational Tables. The  light-gray  boxes identify a system function or an informational item.

Table of ContentsPrevious SectionNext SectionCMD for Batch Job
The following (CBLCSVE1.cmd) is a sample of the Windows CMD needed to run this job. This set of programs illustrates the use of Micro Focus COBOL programs that will read a column-oriented, ASCII/Text file with a fixed-field-length (FFL) and create an ASCII/Text file with a comma-separated-values (CSV) format.

@echo OFF
rem  * *******************************************************************
rem  *               CBLCSVE1.CMD - a Windows Command File               *
rem  *         This program is provided by SimoTime Technologies         *
rem  *           (C) Copyright 1987-2019 All Rights Reserved             *
rem  *             Web Site URL:   http://www.simotime.com               *
rem  *                   e-mail:   helpdesk@simotime.com                 *
rem  * *******************************************************************
rem  *
rem  * Text    - COBOL, read an LFFL file and create an LCSV file.
rem  * Author  - SimoTime Technologies
rem  * Date    - December 12, 2003
rem  * Version - 04.01.20
rem  *
rem  * This set of programs illustrates the use of COBOL programs to read
rem  * a column-oriented, ASCII/Text file with a Fixed-Field-Length (FFL)
rem  * and create an ASCII/Text file with a Comma-Separated-Values (CSV)
rem  * format.
rem  *
rem  * The COBOL program is compiled with the ASSIGN(EXTERNAL) directive.
rem  * This provides for external file mapping of the file names.
rem  *
rem  * This set of programs will run on a Personal Computer with Windows
rem  * and Micro Focus Net Express.
rem  *
rem  *                     ************
rem  *                     * CblCsvE1 *
rem  *                     ********cmd*
rem  *                          *
rem  *                          *
rem  *                     ************     ************
rem  *                     * if EXIST ******* CUSTLCSV *
rem  *                     *******stmt*  *  ******erase*
rem  *                          *
rem  *                          *
rem  *    ************     ************     ************
rem  *    * CUSTLFFL ******* CblCsvC1 ******* CUSTLCSV *
rem  *    *******lffl*     ********cbl*     *******lcsv*
rem  *                          *
rem  *                          *
rem  *                     ************
rem  *                     *   EOJ    *
rem  *                     ************
rem  *
rem  * Note-1: LCSV=Line Sequential with Comma-Separated-Values format.
rem  * Note-2: LFFL=Line Sequential with Fixed-Field-Length format.
rem  *
rem  * ********************************************************************
rem  * Step   1 of 2  Set the global environment variables...
rem  *
     call ..\Env1BASE
     if "%SYSLOG%" == "" set syslog=c:\SimoLIBR\LOGS\SimoTime.LOG
     set JobName=CblCsvE1
rem  *
     call SimoNOTE "*******************************************************%JobName%"
     call SimoNOTE "Starting JobName %JobName%, User is %USERNAME%"
rem  * *******************************************************************
rem  * Step   2 of 2  Execute the program, create a CSV file.
rem  *
     set CUSTLFFL=%BaseLib1%\DATA\TXT1\SIMOTIME.TEXT.CUSTLFFL.TXT
     set CUSTLCSV=%BaseLib1%\DATA\WRK1\SIMOTIME.TEXT.CUSTLCSV.CSV
     set SYSOUT=%BaseLib1%\LOGS\SIMOTIME.SYSOUT.CBLCSVE1.TXT
     if exist %CUSTLCSV% erase %CUSTLCSV%
:CblCsvC1
     run CblCsvC1
     if not "%ERRORLEVEL%" == "0" set JobStatus=0010
     if not %JobStatus% == 0000 goto :EojNok
rem  *
     if exist %CUSTLCSV% goto :EojAok
     set JobStatus=0020
     goto :EojNok
:EojAok
     call SimoNOTE "DataTake CUSTLFFL=%CUSTLFFL%"
     call SimoNOTE "DataMake CUSTLCSV=%CUSTLCSV%"
     call SimoNOTE "Finished JobName %JobName%, Job Status is %JobStatus%"
     goto :End
:EojNok
     call SimoNOTE "ABENDING JobName %JobName%, Job Status is %JobStatus%"
:End
     call SimoNOTE "Conclude SysLog is %SYSLOG%"
     if not "%1" == "nopause" pause

Table of ContentsPrevious SectionNext SectionThe COBOL Programs
The conversion process uses two (2) programs. The mainline program does the file I/O and calls the conversion routine to the record content conversion. The following describes the two programs.

Table of ContentsPrevious SectionNext SectionThe COBOL I/O Program
The following (CBLCSVC1.cbl) is a sample of the Micro Focus COBOL demonstration program. This program will not compile or execute on an IBM Mainframe because of the ORGANIZATION IS LINE SEQUENTIAL on the SELECT statement. If the statement was changed to read ORGANIZATION IS SEQUENTIAL it would run on an IBM Mainframe and "read from" and "write to" a sequential file. The program was tested using Micro Focus Net Express, version 6.0 running on Windows/7.

       IDENTIFICATION DIVISION.
       PROGRAM-ID.    .
       AUTHOR.        SIMOTIMeCopy.
      *****************************************************************
      *           This program was generated by SimoZAPS              *
      *             A product of SimoTime Technologies                *
      *        Our e-mail address is: helpdesk@simotime.com           *
      *     Also, visit our Web Site at http://www.simotime.com       *
      *                                                               *
      *  Generation Date: 2012-01-16  Generation Time: 13:01:02:16    *
      *                                                               *
      *                                   Record    Record     Key    *
      *  Function  Name     Organization  Format    Max-Min  Pos-Len  *
      *  INPUT     CUSTLFFL ASCII/CRLF    FIXED      00512            *
      *                                                               *
      *  OUTPUT    CUSTLCSV ASCII/CRLF    VARIABLE   00512            *
      *                                                               *
      *                                                               *
      *****************************************************************
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT CUSTLFFL-FILE  ASSIGN TO       CUSTLFFL
                  ORGANIZATION  IS LINE SEQUENTIAL
                  ACCESS MODE   IS SEQUENTIAL
                  FILE STATUS   IS CUSTLFFL-STATUS.
           SELECT CUSTLCSV-FILE  ASSIGN TO       CUSTLCSV
                  ORGANIZATION  IS LINE SEQUENTIAL
                  ACCESS MODE   IS SEQUENTIAL
                  FILE STATUS   IS CUSTLCSV-STATUS.

      *****************************************************************
       DATA DIVISION.
       FILE SECTION.
       FD  CUSTLFFL-FILE
           DATA RECORD    IS CUSTLFFL-REC
           .
       01  CUSTLFFL-REC.
           05  CUSTLFFL-DATA-01 PIC X(00512).

       FD  CUSTLCSV-FILE
           DATA RECORD    IS CUSTLCSV-REC
           .
       01  CUSTLCSV-REC.
           05  CUSTLCSV-DATA-01 PIC X(00512).

      *****************************************************************
      * This program was created with the SYSMASK3.TXT file as the    *
      * template for the File I/O. It is intended for use with the    *
      * TransCALL facility that makes a call to a routine that does   *
      * the actual conversion between EBCDIC and ASCII. For more      *
      * information or questions contact SimoTime Technologies.       *
      *                                                               *
      *        Our e-mail address is: helpdesk@simotime.com           *
      *     Also, visit our Web Site at http://www.simotime.com       *
      *                                                               *
      * The SYSMASK3 provides for the sequential reading of the input *
      * file and the sequential writing of the output file.           *
      *                                                               *
      * This program mask is used with a callable subroutine that     *
      * will do ASCII/EBCDIC Conversion based on a COBOL Copy File.   *
      *                                                               *
      * If the output file is indexed then the input file must be in  *
      * sequence by the field that will be used to provide the key    *
      * for the output file.                                          *
      *                                                               *
      * If the key field is not in sequence then refer to SYSMASK4    *
      * to provide for a random add or update of the indexed file.    *
      *****************************************************************
       WORKING-STORAGE SECTION.
       01  SIM-TITLE.
           05  T1 pic X(11) value '* CBLCSVC1 '.
           05  T2 pic X(34) value 'Convert a CUSTLFFL to a CUSTLCSV  '.
           05  T3 pic X(10) value ' v10.07.06'.
           05  T4 pic X(24) value '   helpdesk@simotime.com'.
       01  SIM-COPYRIGHT.
           05  C1 pic X(11) value '* CBLCSVC1 '.
           05  C2 pic X(32) value 'This Data File Convert Member wa'.
           05  C3 pic X(32) value 's generated by SimoTime Technolo'.
           05  C4 pic X(04) value 'gies'.

       01  CUSTLFFL-STATUS.
           05  CUSTLFFL-STATUS-L     pic X.
           05  CUSTLFFL-STATUS-R     pic X.
       01  CUSTLFFL-EOF              pic X       value 'N'.
       01  CUSTLFFL-OPEN-FLAG        pic X       value 'C'.

       01  CUSTLCSV-STATUS.
           05  CUSTLCSV-STATUS-L     pic X.
           05  CUSTLCSV-STATUS-R     pic X.
       01  CUSTLCSV-EOF              pic X       value 'N'.
       01  CUSTLCSV-OPEN-FLAG        pic X       value 'C'.

       01  CUSTLFFL-LRECL            pic 9(5)    value 00512.
       01  CUSTLCSV-LRECL            pic 9(5)    value 00512.

      *****************************************************************
      * The following buffers are used to create a four-byte status   *
      * code that may be displayed.                                   *
      *****************************************************************
       01  IO-STATUS.
           05  IO-STAT1            pic X.
           05  IO-STAT2            pic X.
       01  IO-STATUS-04.
           05  IO-STATUS-0401      pic 9     value 0.
           05  IO-STATUS-0403      pic 999   value 0.
       01  TWO-BYTES-BINARY        pic 9(4)  BINARY.
       01  TWO-BYTES-ALPHA         redefines TWO-BYTES-BINARY.
           05  TWO-BYTES-LEFT      pic X.
           05  TWO-BYTES-RIGHT     pic X.

      *****************************************************************
      * Message Buffer used by the Z-DISPLAY-MESSAGE-TEXT routine.    *
      *****************************************************************
       01  MESSAGE-BUFFER.
           05  MESSAGE-HEADER      pic X(11)   value '* CBLCSVC1 '.
           05  MESSAGE-TEXT.
               10  MESSAGE-TEXT-1  pic X(68)   value SPACES.
               10  MESSAGE-TEXT-2  pic X(188)  value SPACES.

      *****************************************************************
       01  PROGRAM-NAME            pic X(8)     value 'CBLCSVC1'.

       01  INFO-STATEMENT.
           05  INFO-SHORT.
               10  INFO-ID pic X(8)    value 'Starting'.
               10  filler  pic X(2)    value ', '.
               10  filler  pic X(34)
                   value   'Convert a CUSTLFFL to a CUSTLCSV  '.
           05  filler      pic X(24)
               value ' http://www.SimoTime.com'.

       01  APPL-RESULT             pic S9(9)    comp.
           88  APPL-AOK            value 0.
           88  APPL-EOF            value 16.

       01  CUSTLFFL-TOTAL.
           05  CUSTLFFL-RDR  pic 9(9)    value 0.
           05  filler      pic X(3)    value ' - '.
           05  filler      pic X(23)   value 'Line count for CUSTLFFL'.
       01  CUSTLCSV-TOTAL.
           05  CUSTLCSV-ADD  pic 9(9)    value 0.
           05  filler      pic X(3)    value ' - '.
           05  filler      pic X(23)   value 'Line count for CUSTLCSV'.

      *****************************************************************
       PROCEDURE DIVISION.
           move all '*' to MESSAGE-TEXT-1
           perform Z-DISPLAY-MESSAGE-TEXT
           move INFO-STATEMENT to MESSAGE-TEXT-1
           perform Z-DISPLAY-MESSAGE-TEXT
           move all '*' to MESSAGE-TEXT-1
           perform Z-DISPLAY-MESSAGE-TEXT
           perform Z-POST-COPYRIGHT
           perform CUSTLFFL-OPEN
           perform CUSTLCSV-OPEN

           perform until CUSTLFFL-STATUS not = '00'
               perform CUSTLFFL-READ
               if  CUSTLFFL-STATUS = '00'
                   add 1 to CUSTLFFL-RDR
                   perform BUILD-OUTPUT-RECORD
                   perform CUSTLCSV-WRITE
                   if  CUSTLCSV-STATUS = '00'
                       add 1 to CUSTLCSV-ADD
                   end-if
               end-if
           end-perform

           move CUSTLFFL-TOTAL to MESSAGE-TEXT
           perform Z-DISPLAY-MESSAGE-TEXT

           move CUSTLCSV-TOTAL to MESSAGE-TEXT
           perform Z-DISPLAY-MESSAGE-TEXT

           if  APPL-EOF
               move 'Complete' to INFO-ID
           else
               move 'ABENDING' to INFO-ID
           end-if
           move INFO-STATEMENT to MESSAGE-TEXT(1:79)
           perform Z-DISPLAY-MESSAGE-TEXT

           perform CUSTLCSV-CLOSE
           perform CUSTLFFL-CLOSE
           GOBACK.

      *****************************************************************
       BUILD-OUTPUT-RECORD.
      *    Extract CALL process...
           call 'CBLCSVR1'                        using CUSTLCSV-REC
                                                        CUSTLFFL-REC
           add 00512 to ZERO giving CUSTLCSV-LRECL
           exit.

      *****************************************************************
      * I/O Routines for the INPUT File...                            *
      *****************************************************************
       CUSTLFFL-CLOSE.
           add 8 to ZERO giving APPL-RESULT.
           close CUSTLFFL-FILE
           if  CUSTLFFL-STATUS = '00'
               subtract APPL-RESULT from APPL-RESULT
           else
               add 12 to ZERO giving APPL-RESULT
           end-if
           if  APPL-AOK
               CONTINUE
           else
               move 'CLOSE Failure with CUSTLFFL' to MESSAGE-TEXT
               perform Z-DISPLAY-MESSAGE-TEXT
               move CUSTLFFL-STATUS to IO-STATUS
               perform Z-DISPLAY-IO-STATUS
               perform Z-ABEND-PROGRAM
           end-if
           exit.
      *---------------------------------------------------------------*
       CUSTLFFL-READ.
           read CUSTLFFL-FILE
           if  CUSTLFFL-STATUS = '00'
               subtract APPL-RESULT from APPL-RESULT
           else
               if  CUSTLFFL-STATUS = '10'
                   add 16 to ZERO giving APPL-RESULT
               else
                   add 12 to ZERO giving APPL-RESULT
               end-if
           end-if
           if  APPL-AOK
               CONTINUE
           else
               if  APPL-EOF
                   move 'Y' to CUSTLFFL-EOF
               else
                   move 'READ Failure with CUSTLFFL' to MESSAGE-TEXT
                   perform Z-DISPLAY-MESSAGE-TEXT
                   move CUSTLFFL-STATUS to IO-STATUS
                   perform Z-DISPLAY-IO-STATUS
                   perform Z-ABEND-PROGRAM
               end-if
           end-if
           exit.
      *---------------------------------------------------------------*
       CUSTLFFL-OPEN.
           add 8 to ZERO giving APPL-RESULT.
           open input CUSTLFFL-FILE
           if  CUSTLFFL-STATUS = '00'
               subtract APPL-RESULT from APPL-RESULT
               move 'O' to CUSTLFFL-OPEN-FLAG
           else
               add 12 to ZERO giving APPL-RESULT
           end-if
           if  APPL-AOK
               CONTINUE
           else
               move 'OPEN Failure with CUSTLFFL' to MESSAGE-TEXT
               perform Z-DISPLAY-MESSAGE-TEXT
               move CUSTLFFL-STATUS to IO-STATUS
               perform Z-DISPLAY-IO-STATUS
               perform Z-ABEND-PROGRAM
           end-if
           exit.

      *****************************************************************
      * I/O Routines for the OUTPUT File...                           *
      *****************************************************************
       CUSTLCSV-WRITE.
           if  CUSTLCSV-OPEN-FLAG = 'C'
               perform CUSTLCSV-OPEN
           end-if
           write CUSTLCSV-REC
           if  CUSTLCSV-STATUS = '00'
               subtract APPL-RESULT from APPL-RESULT
           else
               if  CUSTLCSV-STATUS = '10'
                   add 16 to ZERO giving APPL-RESULT
               else
                   add 12 to ZERO giving APPL-RESULT
               end-if
           end-if.
           if  APPL-AOK
               CONTINUE
           else
               move 'WRITE Failure with CUSTLCSV' to MESSAGE-TEXT
               perform Z-DISPLAY-MESSAGE-TEXT
               move CUSTLCSV-STATUS to IO-STATUS
               perform Z-DISPLAY-IO-STATUS
               perform Z-ABEND-PROGRAM
           end-if
           exit.
      *---------------------------------------------------------------*
       CUSTLCSV-OPEN.
           add 8 to ZERO giving APPL-RESULT.
           open OUTPUT CUSTLCSV-FILE
           if  CUSTLCSV-STATUS = '00'
               subtract APPL-RESULT from APPL-RESULT
               move 'O' to CUSTLCSV-OPEN-FLAG
           else
               add 12 to ZERO giving APPL-RESULT
           end-if
           if  APPL-AOK
               CONTINUE
           else
               move 'OPEN Failure with CUSTLCSV' to MESSAGE-TEXT
               perform Z-DISPLAY-MESSAGE-TEXT
               move CUSTLCSV-STATUS to IO-STATUS
               perform Z-DISPLAY-IO-STATUS
               perform Z-ABEND-PROGRAM
           end-if
           exit.
      *---------------------------------------------------------------*
       CUSTLCSV-CLOSE.
           add 8 to ZERO giving APPL-RESULT.
           close CUSTLCSV-FILE
           if  CUSTLCSV-STATUS = '00'
               subtract APPL-RESULT from APPL-RESULT
               move 'C' to CUSTLCSV-OPEN-FLAG
           else
               add 12 to ZERO giving APPL-RESULT
           end-if
           if  APPL-AOK
               CONTINUE
           else
               move 'CLOSE Failure with CUSTLCSV' to MESSAGE-TEXT
               perform Z-DISPLAY-MESSAGE-TEXT
               move CUSTLCSV-STATUS to IO-STATUS
               perform Z-DISPLAY-IO-STATUS
               perform Z-ABEND-PROGRAM
           end-if
           exit.

      *****************************************************************
      * The following Z-ROUTINES provide administrative functions     *
      * for this program.                                             *
      *****************************************************************
      * ABEND the program, post a message to the console and issue    *
      * a STOP RUN.                                                   *
      *****************************************************************
       Z-ABEND-PROGRAM.
           if  MESSAGE-TEXT not = SPACES
               perform Z-DISPLAY-MESSAGE-TEXT
           end-if
           move 'PROGRAM-IS-ABENDING...'  to MESSAGE-TEXT
           perform Z-DISPLAY-MESSAGE-TEXT
           add 12 to ZERO giving RETURN-CODE
           STOP RUN.
      *    exit.

      *****************************************************************
      * Display CONSOLE messages...                                   *
      *****************************************************************
       Z-DISPLAY-MESSAGE-TEXT.
           if MESSAGE-TEXT-2 = SPACES
               display MESSAGE-BUFFER(1:79)
           else
               display MESSAGE-BUFFER
           end-if
           move all SPACES to MESSAGE-TEXT
           exit.

      *****************************************************************
      * Display the file status bytes. This routine will display as   *
      * four digits. If the full two byte file status is numeric it   *
      * will display as 00nn. If the 1st byte is a numeric nine (9)   *
      * the second byte will be treated as a binary number and will   *
      * display as 9nnn.                                              *
      *****************************************************************
       Z-DISPLAY-IO-STATUS.
           if  IO-STATUS not NUMERIC
           or  IO-STAT1 = '9'
               move IO-STAT1 to IO-STATUS-04(1:1)
               subtract TWO-BYTES-BINARY from TWO-BYTES-BINARY
               move IO-STAT2 to TWO-BYTES-RIGHT
               add TWO-BYTES-BINARY to ZERO giving IO-STATUS-0403
               move 'File Status is: nnnn' to MESSAGE-TEXT
               move IO-STATUS-04 to MESSAGE-TEXT(17:4)
               perform Z-DISPLAY-MESSAGE-TEXT
           else
               move '0000' to IO-STATUS-04
               move IO-STATUS to IO-STATUS-04(3:2)
               move 'File Status is: nnnn' to MESSAGE-TEXT
               move IO-STATUS-04 to MESSAGE-TEXT(17:4)
               perform Z-DISPLAY-MESSAGE-TEXT
           end-if
           exit.

      *****************************************************************
       Z-POST-COPYRIGHT.
           display SIM-TITLE
           display SIM-COPYRIGHT
           exit.
      *****************************************************************
      *           This program was generated by SimoZAPS              *
      *             A product of SimoTime Technologies                *
      *        Our e-mail address is: helpdesk@simotime.com           *
      *     Also, visit our Web Site at http://www.simotime.com       *
      *                                                               *
      *  Generation Date: 2012-01-16  Generation Time: 13:01:02:19    *
      *****************************************************************

Table of ContentsPrevious SectionNext SectionThe COBOL Convert Routine
The following (CBLCSVR1.cbl) is a sample of the Micro Focus COBOL conversion routine from Fixed-Field-Length (FFL) to Comma-Separated-Values (CSV) formats. The program was tested using Micro Focus Net Express, version 6.0 running on Windows/7.

       IDENTIFICATION DIVISION.
       PROGRAM-ID.    CBLCSVR1.
       AUTHOR.        SIMOTIME TECHNOLOGIES.
      *****************************************************************
      *           This routine was generated by SimoREC1              *
      *             A product of SimoTime Technologies                *
      *        Our e-mail address is: helpdesk@simotime.com           *
      *     Also, visit our Web Site at http://www.simotime.com       *
      *  Generation Date: 2012/01/16  Generation Time: 13:01:02:38    *
      *****************************************************************
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  NGZU-12-00.
           05  NRZU-12-00  pic  9(12).

       01  IX-P1               pic 9(9)      value 0.
       01  IX-P2               pic 9(9)      value 0.
       01  IX-NP               pic 9(5)      value 0.
       01  IX-L1               pic 9(9)      value 0.
       01  RA-P1               pic 9(3)      value 0.
       01  RA-P2               pic 9(3)      value 0.
       01  COLUMN-NUMBER       pic 9(5)      value 0.
       01  WORK-AREA-X.
           05  WORK-AREA-X1    pic X         value '"'.
           05  WORK-AREA       pic X(00544)  value SPACES.
       01  WORK-AREA-X2        pic X(00512)  value SPACES.
       01  FRAME-STOP.
           05  FRAME-BYTE      pic X         value '"'.
           05  DELIMITER-BYTE  pic X         value ','.
       01  FRAME-FLAG          pic X         value 'N'.
       01  O-FLAG              pic X(3)      value 'CSV'.
       01  BYTE-Y              pic X         value 'Y'.
       01  BYTE-N              pic X         value 'N'.
       01  FRAME-COUNT         pic 9(5)      value 0.
       01  DELIM-COUNT         pic 9(5)      value 0.
       01  FFL-SIZE            pic 9(5)      value 0.
       01  CSV-SIZE            pic 9(5)      value 0.
       01  LAST-NON-SPACE-BYTE pic 9(5)      value 0.
       01  SIGN-BYTE           pic X         value SPACE.
       01  DIG-POS             pic 9(3).
       01  DIG-LEN             pic 9(3).
       01  DIG-CTL             pic 9(3).
       01  DEC-POS             pic 9(3).
       01  DEC-LEN             pic 9(3).
       01  DEC-CTL             pic 9(3).
       01  DEC-POINT           pic 9(3).
      *
      *****************************************************************
       LINKAGE SECTION.
       01  REC1CALL-REC pic X(00512).
       COPY CUSTTXB1.
      *
      *****************************************************************
       PROCEDURE DIVISION using REC1CALL-REC
                                CUSTTEXT-RECORD.
      *
           add 1 to ZERO giving IX-NP
           move all SPACES
             to REC1CALL-REC
      *
      *    Number-UnSign move, CUSTTEXT-KEY
           add 00012 to ZERO giving FFL-SIZE
           if CUSTTEXT-KEY is NUMERIC
              add CUSTTEXT-KEY to ZERO giving NRZU-12-00
           else
              move ZERO to NRZU-12-00
           end-if
           move SPACES to WORK-AREA-X2
           move NGZU-12-00 to WORK-AREA-X2
           perform POST-TEXT-TO-CSV
      *
      *    String Move, CUSTTEXT-STATUS
           add 00001 to ZERO giving FFL-SIZE
           move SPACES to WORK-AREA-X2
           move CUSTTEXT-STATUS to WORK-AREA-X2
           perform POST-TEXT-TO-CSV
      *
      *    String Move, CUSTTEXT-LAST-NAME
           add 00028 to ZERO giving FFL-SIZE
           move SPACES to WORK-AREA-X2
           move CUSTTEXT-LAST-NAME to WORK-AREA-X2
           perform POST-TEXT-TO-CSV
      *
      *    String Move, CUSTTEXT-FIRST-NAME
           add 00020 to ZERO giving FFL-SIZE
           move SPACES to WORK-AREA-X2
           move CUSTTEXT-FIRST-NAME to WORK-AREA-X2
           perform POST-TEXT-TO-CSV
      *
      *    String Move, CUSTTEXT-STREET-ADDR-01
           add 00048 to ZERO giving FFL-SIZE
           move SPACES to WORK-AREA-X2
           move CUSTTEXT-STREET-ADDR-01
                                      to WORK-AREA-X2
           perform POST-TEXT-TO-CSV
      *
      *    String Move, CUSTTEXT-STREET-ADDR-02
           add 00048 to ZERO giving FFL-SIZE
           move SPACES to WORK-AREA-X2
           move CUSTTEXT-STREET-ADDR-02
                                      to WORK-AREA-X2
           perform POST-TEXT-TO-CSV
      *
      *    String Move, CUSTTEXT-CITY
           add 00016 to ZERO giving FFL-SIZE
           move SPACES to WORK-AREA-X2
           move CUSTTEXT-CITY to WORK-AREA-X2
           perform POST-TEXT-TO-CSV
      *
      *    String Move, CUSTTEXT-STATE
           add 00002 to ZERO giving FFL-SIZE
           move SPACES to WORK-AREA-X2
           move CUSTTEXT-STATE to WORK-AREA-X2
           perform POST-TEXT-TO-CSV
      *
      *    String Move, CUSTTEXT-POSTAL-CODE
           add 00012 to ZERO giving FFL-SIZE
           move SPACES to WORK-AREA-X2
           move CUSTTEXT-POSTAL-CODE to WORK-AREA-X2
           perform POST-TEXT-TO-CSV
           GOBACK.
      *
      *****************************************************************
       POST-TEXT-TO-CSV.
      *    This routine does a left-to-right scan of the content
      *    of a fixed-field. It accumulates counters for the
      *    embedded Frame or Delimiter bytes.
      *    If embedded Frame or Delimiters bytes exist in the
      *    text string within a field then the text string will
      *    be formated as it is moved to the output buffer.
      *    The data in the output buffer will start and end with
      *    a Frame byte
      *    Embedded Frame bytes will be preceded by a Frame byte
      *    and embedded Delimiter bytes will be treated as data
      *    within the output text string.
      *****************************************************************
           add 1 to ZERO giving IX-P1
           add 1 to ZERO giving IX-P2
           move ZERO to FRAME-COUNT
           move ZERO to DELIM-COUNT
           move ZERO to LAST-NON-SPACE-BYTE
           move SPACES to WORK-AREA
           perform until IX-P1 > FFL-SIZE
               move WORK-AREA-X2(IX-P1:1) to WORK-AREA(IX-P2:1)
               if  WORK-AREA-X2(IX-P1:1) = FRAME-BYTE
                   add 1 to IX-P2
                   add 1 to FRAME-COUNT
                   move FRAME-BYTE to WORK-AREA(IX-P2:1)
               end-if
               if  WORK-AREA-X2(IX-P1:1) = DELIMITER-BYTE
                   add 1 to DELIM-COUNT
               end-if
               if  WORK-AREA-X2(IX-P1:1) not = SPACE
                   add IX-P2 to ZERO giving LAST-NON-SPACE-BYTE
               end-if
               add 1 to IX-P1
               add 1 to IX-P2
           end-perform
           if  DELIM-COUNT > 0
           or  FRAME-COUNT > 0
               add 1 to LAST-NON-SPACE-BYTE
               move FRAME-BYTE to WORK-AREA(LAST-NON-SPACE-BYTE:1)
               add 1 to IX-P2
               add LAST-NON-SPACE-BYTE to 1 giving CSV-SIZE
               move WORK-AREA-X to REC1CALL-REC(IX-NP:CSV-SIZE)
           else
               add LAST-NON-SPACE-BYTE to ZERO giving CSV-SIZE
               move WORK-AREA to REC1CALL-REC(IX-NP:CSV-SIZE)
           end-if
           add CSV-SIZE to IX-NP
           move DELIMITER-BYTE to REC1CALL-REC(IX-NP:1)
           add 1 to IX-NP
           exit.
      *****************************************************************
      *           This routine was generated by SimoREC1              *
      *             A product of SimoTime Technologies                *
      *        Our e-mail address is: helpdesk@simotime.com           *
      *     Also, visit our Web Site at http://www.simotime.com       *
      *  Generation Date: 2012/01/16  Generation Time: 13:01:02:38    *
      *****************************************************************

Table of ContentsPrevious SectionNext SectionRecord Layout, Fixed-Field Length
The following (CUSTTXB1.cpy) is the record layout of the column-oriented, fixed-field-length, Customer Master file.

      *****************************************************************
      *               CUSTTXB1.CPY - a COBOL Copy File                *
      *        A Customer Text File used by CSV Demo programs.        *
      *         Copyright (C) 1987-2019 SimoTime Technologies         *
      *                     All Rights Reserved                       *
      *              Provided by SimoTime Technologies                *
      *        Our e-mail address is: helpdesk@simotime.com           *
      *     Also, visit our Web Site at http://www.simotime.com       *
      *****************************************************************
      *    The record length is 512 bytes.
      *
      *    Column  Field Name               Size
      *       -    -----------------------   --
      *       A    CUSTTEXT-KEY              12
      *       B    CUSTTEXT-STATUS           01
      *       C    CUSTTEXT-LAST-NAME        28
      *       D    CUSTTEXT-FIRST-NAME       20
      *       E    CUSTTEXT-STREET-ADDR-01   48
      *       F    CUSTTEXT-STREET-ADDR-02   48
      *       G    CUSTTEXT-CITY             16
      *       H    CUSTTEXT-STATE            02
      *       I    CUSTTEXT-POSTAL-CODE      12
      *       -    -----------------------   --
      *
       01  CUSTTEXT-RECORD.
           05  CUSTTEXT-KEY            PIC 9(12).
           05  CUSTTEXT-STATUS         PIC X.
           05  CUSTTEXT-LAST-NAME      PIC X(28).
           05  CUSTTEXT-FIRST-NAME     PIC X(20).
           05  CUSTTEXT-STREET-ADDR-01 PIC X(48).
           05  CUSTTEXT-STREET-ADDR-02 PIC X(48).
           05  CUSTTEXT-CITY           PIC X(16).
           05  CUSTTEXT-STATE          PIC X(2).
           05  CUSTTEXT-POSTAL-CODE    PIC X(12).
           05  FILLER                  PIC X(325).
      *
      ***  CUSTTXB1 - End-of-Copy File - - - - - - - - - - - CUSTTXB1 *
      *****************************************************************
      *

