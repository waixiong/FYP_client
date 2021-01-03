import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:imageChat/service/auth_service.dart';
import 'package:logger/logger.dart';
import 'package:mailer/smtp_server.dart';
import '../util/network_config.dart';
import '../logger.dart';
import '../locator.dart';
import './_exception.dart';

// import 'package:flutter_email_sender/flutter_email_sender.dart';
// import 'package:flutter_mailer/flutter_mailer.dart';
// import 'package:share/share.dart';
import 'package:mailer/mailer.dart';

class MailService extends ChangeNotifier {

  String _title() => 'Invitation to ImageChat';

  String _body(String repName, String sendName) => '''
<!doctype html>
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:o="urn:schemas-microsoft-com:office:office">

<head>
  <title>
    Invitation to ImageChat
  </title>
  <!--[if !mso]><!-->
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <!--<![endif]-->
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <style type="text/css">
    #outlook a {
      padding: 0;
    }

    body {
      margin: 0;
      padding: 0;
      -webkit-text-size-adjust: 100%;
      -ms-text-size-adjust: 100%;
    }

    table,
    td {
      border-collapse: collapse;
      mso-table-lspace: 0pt;
      mso-table-rspace: 0pt;
    }

    img {
      border: 0;
      height: auto;
      line-height: 100%;
      outline: none;
      text-decoration: none;
      -ms-interpolation-mode: bicubic;
    }

    p {
      display: block;
      margin: 13px 0;
    }
  </style>
  <!--[if mso]>
        <xml>
        <o:OfficeDocumentSettings>
          <o:AllowPNG/>
          <o:PixelsPerInch>96</o:PixelsPerInch>
        </o:OfficeDocumentSettings>
        </xml>
        <![endif]-->
  <!--[if lte mso 11]>
        <style type="text/css">
          .mj-outlook-group-fix { width:100% !important; }
        </style>
        <![endif]-->
  <!--[if !mso]><!-->
  <link href="https://fonts.googleapis.com/css?family=Open Sans" rel="stylesheet" type="text/css">
  <style type="text/css">
    @import url(https://fonts.googleapis.com/css?family=Open Sans);
  </style>
  <!--<![endif]-->
  <style type="text/css">
    @media only screen and (min-width:480px) {
      .mj-column-per-100 {
        width: 100% !important;
        max-width: 100%;
      }
    }
  </style>
  <style type="text/css">
    [owa] .mj-column-per-100 {
      width: 100% !important;
      max-width: 100%;
    }
  </style>
  <style type="text/css">
    @media only screen and (max-width:480px) {
      table.mj-full-width-mobile {
        width: 100% !important;
      }

      td.mj-full-width-mobile {
        width: auto !important;
      }
    }
  </style>
</head>

<body style="word-spacing:normal;background-color:#f8f8f8;">
  <div style="background-color:#f8f8f8;">
    <!--[if mso | IE]><table align="center" border="0" cellpadding="0" cellspacing="0" class="" style="width:600px;" width="600" ><tr><td style="line-height:0px;font-size:0px;mso-line-height-rule:exactly;"><![endif]-->
    <div style="margin:0px auto;max-width:600px;">
      <table align="center" border="0" cellpadding="0" cellspacing="0" role="presentation" style="width:100%;">
        <tbody>
          <tr>
            <td style="direction:ltr;font-size:0px;padding:20px 0px 20px 0px;padding-bottom:0px;padding-top:0px;text-align:center;">
              <!--[if mso | IE]><table role="presentation" border="0" cellpadding="0" cellspacing="0"><tr><td class="" style="vertical-align:top;width:600px;" ><![endif]-->
              <div class="mj-column-per-100 mj-outlook-group-fix" style="font-size:0px;text-align:left;direction:ltr;display:inline-block;vertical-align:top;width:100%;">
                <table border="0" cellpadding="0" cellspacing="0" role="presentation" style="vertical-align:top;" width="100%">
                  <tbody>
                    <tr>
                      <td align="left" style="font-size:0px;padding:0px 0px 0px 25px;padding-top:0px;padding-bottom:0px;word-break:break-word;">
                        <div style="font-family:Open Sans, Helvetica, Arial, sans-serif;font-size:11px;line-height:22px;text-align:left;color:#797e82;">
                          <p style="text-align: center; margin: 10px 0;">Lorem ipsum dolor sit&nbsp;| <a target="_blank" rel="noopener noreferrer" href="#"></a><span style="color:#797e82; text-decoration: underline"> View online version</span></p>
                        </div>
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>
              <!--[if mso | IE]></td></tr></table><![endif]-->
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    <!--[if mso | IE]></td></tr></table><table align="center" border="0" cellpadding="0" cellspacing="0" class="" style="width:600px;" width="600" ><tr><td style="line-height:0px;font-size:0px;mso-line-height-rule:exactly;"><![endif]-->
    <div style="background:#ffffff;background-color:#ffffff;margin:0px auto;max-width:600px;">
      <table align="center" border="0" cellpadding="0" cellspacing="0" role="presentation" style="background:#ffffff;background-color:#ffffff;width:100%;">
        <tbody>
          <tr>
            <td style="direction:ltr;font-size:0px;padding:20px 0px;padding-bottom:0px;padding-left:0px;padding-right:0px;padding-top:0px;text-align:center;">
              <!--[if mso | IE]><table role="presentation" border="0" cellpadding="0" cellspacing="0"><tr><td class="" style="vertical-align:top;width:600px;" ><![endif]-->
              <div class="mj-column-per-100 mj-outlook-group-fix" style="font-size:0px;text-align:left;direction:ltr;display:inline-block;vertical-align:top;width:100%;">
                <table border="0" cellpadding="0" cellspacing="0" role="presentation" style="vertical-align:top;" width="100%">
                  <tbody>
                    <tr>
                      <td align="center" style="font-size:0px;padding:10px 25px;padding-top:0px;padding-right:0px;padding-bottom:40px;padding-left:0px;word-break:break-word;">
                        <p style="border-top:solid 7px #DEDEDE;font-size:1px;margin:0px auto;width:100%;">
                        </p>
                        <!--[if mso | IE]><table align="center" border="0" cellpadding="0" cellspacing="0" style="border-top:solid 7px #DEDEDE;font-size:1px;margin:0px auto;width:600px;" role="presentation" width="600px" ><tr><td style="height:0;line-height:0;"> &nbsp;
</td></tr></table><![endif]-->
                      </td>
                    </tr>
                    <tr>
                      <td align="center" style="font-size:0px;padding:10px 25px;padding-top:0px;padding-bottom:0px;word-break:break-word;">
                        <table border="0" cellpadding="0" cellspacing="0" role="presentation" style="border-collapse:collapse;border-spacing:0px;">
                          <tbody>
                            <tr>
                              <td style="width:110px;">
                                <img alt="" height="auto" src="/saas-templates-creator/static/img/mjml.png" style="border:none;display:block;outline:none;text-decoration:none;height:auto;width:100%;font-size:13px;" title="" width="110" />
                              </td>
                            </tr>
                          </tbody>
                        </table>
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>
              <!--[if mso | IE]></td></tr></table><![endif]-->
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    <!--[if mso | IE]></td></tr></table><table align="center" border="0" cellpadding="0" cellspacing="0" class="" style="width:600px;" width="600" ><tr><td style="line-height:0px;font-size:0px;mso-line-height-rule:exactly;"><![endif]-->
    <div style="background:#ffffff;background-color:#ffffff;margin:0px auto;max-width:600px;">
      <table align="center" border="0" cellpadding="0" cellspacing="0" role="presentation" style="background:#ffffff;background-color:#ffffff;width:100%;">
        <tbody>
          <tr>
            <td style="direction:ltr;font-size:0px;padding:20px 0px;padding-bottom:0px;padding-top:0px;text-align:center;">
              <!--[if mso | IE]><table role="presentation" border="0" cellpadding="0" cellspacing="0"><tr><td class="" style="vertical-align:top;width:600px;" ><![endif]-->
              <div class="mj-column-per-100 mj-outlook-group-fix" style="font-size:0px;text-align:left;direction:ltr;display:inline-block;vertical-align:top;width:100%;">
                <table border="0" cellpadding="0" cellspacing="0" role="presentation" style="vertical-align:top;" width="100%">
                  <tbody>
                    <tr>
                      <td align="center" style="font-size:0px;padding:10px 25px;padding-top:40px;padding-right:50px;padding-bottom:0px;padding-left:50px;word-break:break-word;">
                        <table border="0" cellpadding="0" cellspacing="0" role="presentation" style="border-collapse:collapse;border-spacing:0px;">
                          <tbody>
                            <tr>
                              <td style="width:300px;">
                                <img alt="" height="auto" src="http://9pl9.mjt.lu/tplimg/9pl9/b/yvrt/t65sn.png" style="border:none;display:block;outline:none;text-decoration:none;height:auto;width:100%;font-size:13px;" title="" width="300" />
                              </td>
                            </tr>
                          </tbody>
                        </table>
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>
              <!--[if mso | IE]></td></tr></table><![endif]-->
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    <!--[if mso | IE]></td></tr></table><table align="center" border="0" cellpadding="0" cellspacing="0" class="" style="width:600px;" width="600" ><tr><td style="line-height:0px;font-size:0px;mso-line-height-rule:exactly;"><![endif]-->
    <div style="background:#ffffff;background-color:#ffffff;margin:0px auto;max-width:600px;">
      <table align="center" border="0" cellpadding="0" cellspacing="0" role="presentation" style="background:#ffffff;background-color:#ffffff;width:100%;">
        <tbody>
          <tr>
            <td style="direction:ltr;font-size:0px;padding:20px 0px 20px 0px;padding-bottom:70px;padding-top:30px;text-align:center;">
              <!--[if mso | IE]><table role="presentation" border="0" cellpadding="0" cellspacing="0"><tr><td class="" style="vertical-align:top;width:600px;" ><![endif]-->
              <div class="mj-column-per-100 mj-outlook-group-fix" style="font-size:0px;text-align:left;direction:ltr;display:inline-block;vertical-align:top;width:100%;">
                <table border="0" cellpadding="0" cellspacing="0" role="presentation" style="vertical-align:top;" width="100%">
                  <tbody>
                    <tr>
                      <td align="left" style="font-size:0px;padding:0px 25px 0px 25px;padding-top:0px;padding-right:50px;padding-bottom:0px;padding-left:50px;word-break:break-word;">
                        <div style="font-family:Open Sans, Helvetica, Arial, sans-serif;font-size:13px;line-height:22px;text-align:left;color:#797e82;">
                          <h1 style="text-align:center; color: #000000; line-height:32px">Hi $repName,</h1>
                        </div>
                      </td>
                    </tr>
                    <tr>
                      <td align="left" style="font-size:0px;padding:0px 25px 0px 25px;padding-top:0px;padding-right:50px;padding-bottom:0px;padding-left:50px;word-break:break-word;">
                        <div style="font-family:Open Sans, Helvetica, Arial, sans-serif;font-size:13px;line-height:22px;text-align:left;color:#797e82;">
                          <p style="margin: 10px 0; text-align: center;"><span style="font-weight:bold">$sendName</span> has invited you to join Imagechat.&nbsp;</p>
                          <p style="margin: 10px 0; text-align: center;">Click the button below to download the app. If you&rsquo;re having trouble, please contact our support team.</p>
                          <p style="margin: 10px 0; text-align: center;">No registration is required. Just sign in with your google account.</p>
                        </div>
                      </td>
                    </tr>
                    <tr>
                      <td align="center" vertical-align="middle" style="font-size:0px;padding:10px 25px;padding-top:20px;padding-bottom:10px;word-break:break-word;">
                        <table border="0" cellpadding="0" cellspacing="0" role="presentation" style="border-collapse:separate;line-height:100%;">
                          <tr>
                            <td align="center" bgcolor="#DEDEDE" role="presentation" style="border:none;border-radius:100px;cursor:auto;mso-padding-alt:15px 25px 15px 25px;background:#DEDEDE;" valign="middle">
                              <a href="https://file.angelmortal.xyz/file/testBuc/imagechat-arm64-v8a-release.apk" style="display:inline-block;background:#DEDEDE;color:#222222;font-family:Open Sans, Helvetica, Arial, sans-serif;font-size:13px;font-weight:normal;line-height:120%;margin:0;text-decoration:none;text-transform:none;padding:15px 25px 15px 25px;mso-padding-alt:0px;border-radius:100px;" target="_blank">
                                <b style="font-weight:700"><b style="font-weight:700">Download Android App</b></b>
                              </a>
                            </td>
                          </tr>
                        </table>
                      </td>
                    </tr>
                    <tr>
                      <td align="center" style="font-size:0px;padding:0px 20px 0px 20px;padding-top:0px;padding-bottom:0px;word-break:break-word;">
                        <div style="font-family:Open Sans, Helvetica, Arial, sans-serif;font-size:11px;line-height:22px;text-align:center;color:#797e82;">
                          <!-- <p style="margin: 10px 0;"><a target="_blank" rel="noopener noreferrer" style="color:#DEDEDE" href="#"><span style="color:#DEDEDE">Page 1</span></a><span style="color:#797e82">&nbsp; &nbsp;|&nbsp; &nbsp;</span><a target="_blank" rel="noopener noreferrer" style="color:#DEDEDE" href="#"><span style="color:#DEDEDE">Page 2</span></a><span style="color:#797e82">&nbsp; &nbsp;|&nbsp; &nbsp;</span><a target="_blank" rel="noopener noreferrer" style="color:#DEDEDE" href="#"><span style="color:#DEDEDE">Page 3</span></a></p> -->
                          <p style="margin: 10px 0;"><span style="font-size:10px">Mobile is 32-bit? &nbsp;</span><a target="_blank" rel="noopener noreferrer" style="font-size:10px; color:inherit; text-decoration: none" href="https://file.angelmortal.xyz/file/testBuc/imagechat-armeabi-v7a-release.apk"><span style="color:#BEBEBE"><u>Download 32-bit apk</u></span></a></p>
                        </div>
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>
              <!--[if mso | IE]></td></tr></table><![endif]-->
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    <!--[if mso | IE]></td></tr></table><table align="center" border="0" cellpadding="0" cellspacing="0" class="" style="width:600px;" width="600" ><tr><td style="line-height:0px;font-size:0px;mso-line-height-rule:exactly;"><![endif]-->
    <div style="margin:0px auto;max-width:600px;">
      <table align="center" border="0" cellpadding="0" cellspacing="0" role="presentation" style="width:100%;">
        <tbody>
          <tr>
            <td style="direction:ltr;font-size:0px;padding:20px 0px 20px 0px;padding-bottom:0px;padding-top:20px;text-align:center;">
              <!--[if mso | IE]><table role="presentation" border="0" cellpadding="0" cellspacing="0"><tr><td class="" style="vertical-align:top;width:600px;" ><![endif]-->
              <div class="mj-column-per-100 mj-outlook-group-fix" style="font-size:0px;text-align:left;direction:ltr;display:inline-block;vertical-align:top;width:100%;">
                <table border="0" cellpadding="0" cellspacing="0" role="presentation" style="vertical-align:top;" width="100%">
                  <tbody>
                    <!-- <mj-social align="center" border-radius="6px" font-family="Ubuntu, Helvetica, Arial, sans-serif" font-size="13px" icon-size="30" line-height="22px" mode="horizontal" padding-bottom="0px" padding="10px 25px" text-decoration="none" text-mode="true">
          <mj-social-element background-color="#DEDEDE" name="facebook-noshare" src="http://www.mailjet.com/saas-templates-creator/static/img/facebook_black.png"></mj-social-element>
          <mj-social-element background-color="#DEDEDE" name="twitter-noshare" src="http://www.mailjet.com/saas-templates-creator/static/img/twitter_black.png"></mj-social-element>
          <mj-social-element background-color="#DEDEDE" name="linkedin-noshare" src="http://www.mailjet.com/saas-templates-creator/static/img/linkedin_black.png"></mj-social-element>
        </mj-social> -->
                    <tr>
                      <td align="center" style="font-size:0px;padding:0px 20px 0px 20px;padding-top:0px;padding-bottom:0px;word-break:break-word;">
                        <div style="font-family:Open Sans, Helvetica, Arial, sans-serif;font-size:11px;line-height:22px;text-align:center;color:#797e82;">
                          <!-- <p style="margin: 10px 0;"><a target="_blank" rel="noopener noreferrer" style="color:#DEDEDE" href="#"><span style="color:#DEDEDE">Page 1</span></a><span style="color:#797e82">&nbsp; &nbsp;|&nbsp; &nbsp;</span><a target="_blank" rel="noopener noreferrer" style="color:#DEDEDE" href="#"><span style="color:#DEDEDE">Page 2</span></a><span style="color:#797e82">&nbsp; &nbsp;|&nbsp; &nbsp;</span><a target="_blank" rel="noopener noreferrer" style="color:#DEDEDE" href="#"><span style="color:#DEDEDE">Page 3</span></a></p> -->
                          <p style="margin: 10px 0;"><span style="font-size:10px">Created by&nbsp;</span><a target="_blank" rel="noopener noreferrer" style="font-size:10px; color:inherit; text-decoration: none" href="https://www.mailjet.com/?utm_source=saas_email_templates&amp;utm_medium=logo_footer_email&amp;utm_campaign=invitation_member"><span style="color:#BEBEBE"><u>Mailjet</u></span></a></p>
                        </div>
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>
              <!--[if mso | IE]></td></tr></table><![endif]-->
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    <!--[if mso | IE]></td></tr></table><![endif]-->
  </div>
</body>

</html>
  ''';

  Future<void> sendEmail(String addr, String name) async {
    // await Share.share(_body(name, locator<AuthService>().user.name), subject: _title());
    // final Email email = Email(
    //   body: _body(name, locator<AuthService>().user.name),
    //   subject: _title(),
    //   recipients: [addr],
    //   cc: ['waixiong@siswa.um.edu.my'],
    //   bcc: [],
    //   attachmentPaths: [],
    //   isHTML: true,
    // );
    // await FlutterEmailSender.send(email);

    final message = Message()
      ..recipients.add(addr)
      ..ccRecipients.addAll(['waixiong@siswa.um.edu.my'])
      ..subject = _title()
      // ..text = 'This is the plain text.\nThis is line 2 of the text part.'
      ..html = _body(name, locator<AuthService>().user.name);
    message.from = Address('wx.chee@getitqec.com', 'ImageChat @ FYP');
    final smtpServer = SmtpServer(
      'smtp.zoho.com',
      port: 587,
      username: 'wx.chee@getitqec.com', 
      password: 'ut1wLQL5Y0Rh'
    );
    await send(message, smtpServer);
  }

  // Future<void> sendEmail(String addr, String name) async {
  //   final MailOptions mailOptions = MailOptions(
  //     body: _body(name, locator<AuthService>().user.name),
  //     subject: _title(),
  //     recipients: [addr],
  //     isHTML: true,
  //     bccRecipients: [],
  //     ccRecipients: ['waixiong@siswa.um.edu.my'],
  //     attachments: [],
  //   );

  //   final MailerResponse response = await FlutterMailer.send(mailOptions);
  // }
}