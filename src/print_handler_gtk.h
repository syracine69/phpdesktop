// Copied from upstream CEF with minor modifications for PHP Desktop
// purposes.

// Copyright (c) 2014 The Chromium Embedded Framework Authors.
// Portions Copyright (c) 2012 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#ifndef CEF_TESTS_CEFCLIENT_BROWSER_PRINT_HANDLER_GTK_H_
#define CEF_TESTS_CEFCLIENT_BROWSER_PRINT_HANDLER_GTK_H_
#pragma once

#include <map>

#include "include/cef_print_handler.h"
#include "include/base/cef_bind.h"
#include "include/base/cef_callback.h"
#include "include/base/cef_callback_forward.h"
#include "include/base/cef_callback_helpers.h"
#include "include/base/cef_callback_list.h"
#include "include/base/cef_ref_counted.h"
#include "include/base/cef_logging.h"
#include "include/base/cef_macros.h"
#include "include/cef_callback.h"
#include "include/cef_task.h"
#include "include/cef_base.h"
#include "include/cef_browser.h"
#include "include/wrapper/cef_helpers.h"

class ClientPrintHandlerGtk : public CefPrintHandler {
 public:
  ClientPrintHandlerGtk();
  virtual ~ClientPrintHandlerGtk();

  // CefPrintHandler methods.
  void OnPrintStart(CefRefPtr<CefBrowser> browser) override;
  void OnPrintSettings(CefRefPtr<CefBrowser> browser,
                       CefRefPtr<CefPrintSettings> settings,
                       bool get_defaults) override;
  bool OnPrintDialog(CefRefPtr<CefBrowser> browser,
                     bool has_selection,
                     CefRefPtr<CefPrintDialogCallback> callback) override;
  bool OnPrintJob(CefRefPtr<CefBrowser> browser,
                  const CefString& document_name,
                  const CefString& pdf_file_path,
                  CefRefPtr<CefPrintJobCallback> callback) override;
  void OnPrintReset(CefRefPtr<CefBrowser> browser) override;
  CefSize GetPdfPaperSize(CefRefPtr<CefBrowser> browser,
                          int device_units_per_inch) override;

 private:
  // Print handler.
  struct PrintHandler;
  PrintHandler* GetPrintHandler(CefRefPtr<CefBrowser> browser);

  // Map of browser ID to print handler.
  typedef std::map<int, PrintHandler*> PrintHandlerMap;
  PrintHandlerMap print_handler_map_;

  IMPLEMENT_REFCOUNTING(ClientPrintHandlerGtk);
  DISALLOW_COPY_AND_ASSIGN(ClientPrintHandlerGtk);
};
#endif  // CEF_TESTS_CEFCLIENT_BROWSER_PRINT_HANDLER_GTK_H_
