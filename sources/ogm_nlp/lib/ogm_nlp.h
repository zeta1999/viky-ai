/*
 *  Internal header for Natural Language Processing library
 *  Copyright (c) 2017 Pertimm by Patrick Constant
 *  Dev: September 2017
 *  Version 1.0
 */
#include <lognlp.h>
#include <logheap.h>
#include <logis639_3166.h>
#include <glib-2.0/glib.h>

#define DOgNlpPackageNumber 0x10
#define DOgNlpPackageBaNumber 0x100
#define DOgNlpPackageIntentNumber 0x10
#define DOgNlpPackagePhraseNumber (DOgNlpPackageIntentNumber*0x10)
#define DOgNlpIntentPhraseMaxLength 0x800

#define DOgNlpiPackageNumber  0x10

struct sentence
{
  int text_start, text_length;
  int locale;
};

struct intent
{
  int id_start, id_length;
  int sentence_start, sentences_nb;
};

struct package
{
  og_nlp ctrl_nlp;
  int id_start, id_length;
  og_heap hba;
  og_heap hintent;
  og_heap hsentence;
};

typedef struct package *package_t;

struct interpret_package
{
  package_t package;
};

struct og_ctrl_nlpi
{
  og_nlp ctrl_nlp;
  void *herr, *hmsg;
  ogmutex_t *hmutex;
  struct og_loginfo loginfo[1];
  char *json_interpret_request_string;
  int json_interpret_request_string_length;
  int json_interpret_request_string_length_truncated;
  og_heap hinterpret_package;
  const char *request_sentence;
};

struct og_ctrl_nlp
{
  void *herr, *hmsg;
  ogmutex_t *hmutex;
  struct og_loginfo loginfo[1];
  char *json_compile_request_string;
  int json_compile_request_string_length;
  int json_compile_request_string_length_truncated;

  /** HashTable key: string (package id) , value: package (package_t) */
  GHashTable *packages_hash;
};

/* nlperr.c */
og_status NlpThrowError(og_nlp ctrl_nlp, og_string format, ...);
og_status NlpiThrowError(og_nlpi ctrl_nlpi, og_string format, ...);

/* nlplog.c */
og_status NlpPackageLog(package_t package);
og_status NlpPackageIntentLog(package_t package, int Iintent);
og_status NlpPackageSentenceLog(package_t package, int Isentence);

/* nlpdump.c */
og_status NlpPackageDump(package_t package, json_t *dump_json);
og_status NlpPackageIntentDump(package_t package, int Iintent, json_t *dump_json);
og_status NlpPackageSentenceDump(package_t package, int Isentence, json_t *dump_json);

/* nlpackage.c */
package_t NlpPackageCreate(og_nlp ctrl_nlp, const char *string_id);
og_status NlpPackageDestroy(package_t package);
og_status NlpPackageAdd(og_nlp ctrl_nlp, package_t package);
package_t NlpPackageGet(og_nlp ctrl_nlp, og_string package_id);

