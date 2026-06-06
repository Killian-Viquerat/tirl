#import "@preview/basic-report:0.4.0": *
#import "@preview/codly:1.3.0": *

#import "@preview/codly-languages:0.1.1": *
#show: codly-init.with()

#codly(languages: codly-languages + (tirl: (name: "Tirl", color: rgb("#347FC4"), icon: [])), aliases: ("tirl": "c"))

// Documenter le paradigme ; expliquer comment le langage va y répondre ; présenter les motivations du choix ; établir le cahier des charges prévisionnel de l’implémentation

#show: it => basic-report(
  doc-category: "PLM",
  doc-title: "Rapport HPC - Open Telemetry Collector",
  author: "Valentin Ricard
Killian Viquerat",

  affiliation: "HEIG-VD",
  datetime-fmt: "[year]-[month]-[day]",
  language: "fr",
  compact-mode: true,
  it,
)

= Introduction
