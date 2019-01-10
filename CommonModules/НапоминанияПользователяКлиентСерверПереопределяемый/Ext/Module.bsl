﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2018, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область УстаревшиеПроцедурыИФункции

// Устарела. Следует использовать НапоминанияПользователяПереопределяемый.ПриЗаполненииСпискаРеквизитовИсточникаСДатамиДляНапоминания().
//
// Переопределяет массив реквизитов объекта, относительно которых разрешается устанавливать время напоминания.
// Например, можно скрыть те реквизиты с датами, которые являются служебными или не имеют смысла для 
// установки напоминаний: дата документа или задачи и прочие.
// 
// Параметры:
//  Источник - ЛюбаяСсылка - ссылка на объект, для которого формируется массив реквизитов с датами;
//  МассивРеквизитов - Массив - имена реквизитов (из метаданных), содержащих даты.
//
Процедура ПриЗаполненииСпискаРеквизитовИсточникаСДатамиДляНапоминания(Источник, МассивРеквизитов) Экспорт
	
КонецПроцедуры

// Устарела. Следует использовать НапоминанияПользователяПереопределяемый.ПриОпределенииНастроек().
//
// Переопределяет варианты расписаний для выбора пользователем.
//
// Параметры:
//  Расписания - Соответствие - коллекция расписаний:
//    * Ключ     - Строка - представление расписания;
//    * Значение - РасписаниеРегламентногоЗадания - вариант расписания.
Процедура ПриПолученииСтандартныхРасписанийДляНапоминания(Расписания) Экспорт
	
КонецПроцедуры

// Устарела. Следует использовать НапоминанияПользователяПереопределяемый.ПриОпределенииНастроек().
//
// Переопределяет массив текстовых представлений стандартных интервалов времени.
//
// Параметры:
//  СтандартныеИнтервалы - Массив - содержит строковые представления интервалов времени.
//
Процедура ПриПолученииСтандартныхИнтерваловОповещения(СтандартныеИнтервалы) Экспорт
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
