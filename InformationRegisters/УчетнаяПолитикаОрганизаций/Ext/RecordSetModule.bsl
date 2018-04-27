﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Справочники.Организации.ДополнитьДанныеЗаполненияПриОднофирменномУчете(ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;		
	КонецЕсли;
	
	Если ЭтотОбъект.ВыгрузитьКолонку("СпособОценкиТМЗ").Найти(Перечисления.СпособыОценки.ФИФО) <> Неопределено Тогда
		ВключитьПартионныйУчет();
	КонецЕсли;
	
	ОбновитьПовторноИспользуемыеЗначения();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура отвечает за включение партионного учета на плане счетов
//
Процедура ВключитьПартионныйУчет() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПараметрыУчета = БухгалтерскийУчетСервер.ОпределитьПараметрыУчета();
	Если НЕ ПараметрыУчета.ВестиПартионныйУчет Тогда
		ПараметрыУчета.ВестиПартионныйУчет = Истина;
		ДополнительныеПараметры = ОбщегоНазначенияБПСервер.ПолучитьСтруктуруДополнительныхПараметров();
		ДополнительныеПараметры.УчетТМЗ = Истина;
		ОбщегоНазначенияБПСервер.ПрименитьПараметрыУчета(ПараметрыУчета, ДополнительныеПараметры);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
