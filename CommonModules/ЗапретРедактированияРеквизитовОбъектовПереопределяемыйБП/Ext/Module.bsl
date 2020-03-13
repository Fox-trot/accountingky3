﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// См. ЗапретРедактированияРеквизитовОбъектовПереопределяемый.ПриОпределенииОбъектовСЗаблокированнымиРеквизитами.
Процедура ПриОпределенииОбъектовСЗаблокированнымиРеквизитами(Объекты) Экспорт
	
	// БПКР
	Объекты.Вставить(Метаданные.Справочники.БанковскиеСчета.ПолноеИмя(), "");
	Объекты.Вставить(Метаданные.Справочники.ВидыПоставокНДС.ПолноеИмя(), "");
	Объекты.Вставить(Метаданные.Справочники.ДоговорыКонтрагентов.ПолноеИмя(), "");
	Объекты.Вставить(Метаданные.Справочники.Кассы.ПолноеИмя(), "");
	Объекты.Вставить(Метаданные.Справочники.КатегорииСотрудников.ПолноеИмя(), "");
	Объекты.Вставить(Метаданные.Справочники.КлассификаторТНВЭД.ПолноеИмя(), "");
	Объекты.Вставить(Метаданные.Справочники.КодыПлатежей.ПолноеИмя(), "");
	Объекты.Вставить(Метаданные.Справочники.Номенклатура.ПолноеИмя(), "");

	Объекты.Вставить(Метаданные.ПланыСчетов.Хозрасчетный.ПолноеИмя(), "");
	// Конец БПКР
	
КонецПроцедуры

#КонецОбласти
