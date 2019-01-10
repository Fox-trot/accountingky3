﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2018, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Не Параметры.Свойство("УзелОбменаСсылка", УзелОбменаСсылка) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Заголовок = УзелОбменаСсылка;
	
	ПрочитатьНомераСообщений();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// Производит запись измененных данных и закрывает форму.
//
&НаКлиенте
Процедура ЗаписатьИзмененияУзла(Команда)
	
	ЗаписатьНомераСообщений();
	Оповестить("ИзменениеДанныхУзлаОбмена", УзелОбменаСсылка, ЭтотОбъект);
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ЭтотОбъект() 
	
	Возврат РеквизитФормыВЗначение("Объект");
	
КонецФункции

&НаСервере
Процедура ПрочитатьНомераСообщений()
	
	Данные = ЭтотОбъект().ПолучитьПараметрыУзлаОбмена(УзелОбменаСсылка, "НомерОтправленного, НомерПринятого");
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Данные);
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьНомераСообщений()
	
	Данные = Новый Структура("НомерОтправленного, НомерПринятого", НомерОтправленного, НомерПринятого);
	ЭтотОбъект().УстановитьПараметрыУзлаОбмена(УзелОбменаСсылка, Данные);
	
КонецПроцедуры

#КонецОбласти
