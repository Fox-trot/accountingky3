﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Переопределяет настройки подсистемы.
//
// Параметры:
//  Настройки - Структура - 
//   * Расписания - Соответствие:
//      ** Ключ     - Строка - представление расписания;
//      ** Значение - РасписаниеРегламентногоЗадания - вариант расписания.
//   * СтандартныеИнтервалы - Массив - содержит строковые представления интервалов времени.
Процедура ПриОпределенииНастроек(Настройки) Экспорт
	
КонецПроцедуры

// Переопределяет массив реквизитов объекта, относительно которых разрешается устанавливать время напоминания.
// Например, можно скрыть те реквизиты с датами, которые являются служебными или не имеют смысла для 
// установки напоминаний: дата документа или задачи и прочие.
// 
// Параметры:
//  Источник - ЛюбаяСсылка - ссылка на объект, для которого формируется массив реквизитов с датами;
//  РеквизитыСДатами - Массив - имена реквизитов (из метаданных), содержащих даты.
//
Процедура ПриЗаполненииСпискаРеквизитовИсточникаСДатамиДляНапоминания(Источник, РеквизитыСДатами) Экспорт
	
КонецПроцедуры

#КонецОбласти
