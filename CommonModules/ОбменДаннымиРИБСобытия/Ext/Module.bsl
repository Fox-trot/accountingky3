﻿#Область ПрограммныйИнтерфейс

// Полный.
Процедура ПолныйЗарегистрироватьИзменениеДокументаПередЗаписью(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписьюДокумента("Полный", Источник, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

Процедура ПолныйЗарегистрироватьИзменениеПередЗаписью(Источник, Отказ) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписью("Полный", Источник, Отказ);
	
КонецПроцедуры

Процедура ПолныйЗарегистрироватьИзменениеНабораЗаписейПередЗаписью(Источник, Отказ, Замещение) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписьюРегистра("Полный", Источник, Отказ, Замещение);
	
КонецПроцедуры

Процедура ПолныйЗарегистрироватьИзменениеКонстантыПередЗаписью(Источник, Отказ) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписьюКонстанты("Полный", Источник, Отказ);
	
КонецПроцедуры

Процедура ПолныйЗарегистрироватьУдалениеПередУдалением(Источник, Отказ) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередУдалением("Полный", Источник, Отказ);
	
КонецПроцедуры

// По организации.
Процедура ПоОрганизацииЗарегистрироватьИзменениеКонстантыПередЗаписью(Источник, Отказ) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписьюКонстанты("ПоОрганизации", Источник, Отказ);
	
КонецПроцедуры

Процедура ПоОрганизацииЗарегистрироватьИзменениеНабораЗаписейПередЗаписью(Источник, Отказ, Замещение) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписьюРегистра("ПоОрганизации", Источник, Отказ, Замещение);
	
КонецПроцедуры

Процедура ПоОрганизацииЗарегистрироватьИзменениеДокументаПередЗаписью(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписьюДокумента("ПоОрганизации", Источник, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

Процедура ПоОрганизацииЗарегистрироватьИзменениеПередЗаписью(Источник, Отказ) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписью("ПоОрганизации", Источник, Отказ);
	
КонецПроцедуры

Процедура ПоОрганизацииЗарегистрироватьУдалениеПередУдалением(Источник, Отказ) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередУдалением("ПоОрганизации", Источник, Отказ);
	
КонецПроцедуры

// Автономная работа.

Процедура АвтономнаяРаботаЗарегистрироватьИзменениеКонстантыПередЗаписью(Источник, Отказ) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписьюКонстанты("АвтономнаяРабота", Источник, Отказ);
	
КонецПроцедуры

Процедура АвтономнаяРаботаЗарегистрироватьИзменениеНабораЗаписейПередЗаписью(Источник, Отказ, Замещение) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписьюРегистра("АвтономнаяРабота", Источник, Отказ, Замещение);
	
КонецПроцедуры

Процедура АвтономнаяРаботаЗарегистрироватьИзменениеДокументаПередЗаписью(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписьюДокумента("АвтономнаяРабота", Источник, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

Процедура АвтономнаяРаботаЗарегистрироватьИзменениеПередЗаписью(Источник, Отказ) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписью("АвтономнаяРабота", Источник, Отказ);
	
КонецПроцедуры

Процедура АвтономнаяРаботаЗарегистрироватьУдалениеПередУдалением(Источник, Отказ) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередУдалением("АвтономнаяРабота", Источник, Отказ);
	
КонецПроцедуры

#КонецОбласти