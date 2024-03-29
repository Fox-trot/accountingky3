﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ЗаполненияДокумента

// Процедура заполнения документа на основании.
//
// Параметры:
//	ДанныеЗаполнения - Структура - Данные заполнения документа.
//	
Процедура ЗаполнитьПоРеализацииТоваровУслуг(ДанныеЗаполнения) Экспорт
	
	ДокументОснование = ДанныеЗаполнения;
	
	Организация = ДанныеЗаполнения.Организация;
	Контрагент = ДанныеЗаполнения.Контрагент;
	
	Товары.Очистить();
	Для Каждого СтрокаТабличнойЧасти Из ДанныеЗаполнения.Товары Цикл
		НоваяСтрокаТабличнойЧасти = Товары.Добавить();	
		ЗаполнитьЗначенияСвойств(НоваяСтрокаТабличнойЧасти, СтрокаТабличнойЧасти);
		
		ПараметрыНоменклатуры = Справочники.Номенклатура.ПолучитьПараметрыНоменклатуры(СтрокаТабличнойЧасти.Номенклатура);
		ЗаполнитьЗначенияСвойств(НоваяСтрокаТабличнойЧасти, ПараметрыНоменклатуры);
		
		НоваяСтрокаТабличнойЧасти.КоличествоМест = НоваяСтрокаТабличнойЧасти.Количество;
		
		НоваяСтрокаТабличнойЧасти.МассаГрузаНетто = НоваяСтрокаТабличнойЧасти.Количество * НоваяСтрокаТабличнойЧасти.ВесЕдиницыНоменклатуры;
		НоваяСтрокаТабличнойЧасти.МассаГрузаБрутто = НоваяСтрокаТабличнойЧасти.МассаГрузаНетто + НоваяСтрокаТабличнойЧасти.КоличествоМест * НоваяСтрокаТабличнойЧасти.ВесУпаковки;
		
		НоваяСтрокаТабличнойЧасти.Сумма = СтрокаТабличнойЧасти.Всего;
	КонецЦикла;
	
КонецПроцедуры

// Процедура заполнения документа на основании.
//
// Параметры:
//	ДанныеЗаполнения - Структура - Данные заполнения документа.
//	
Процедура ЗаполнитьПоВозвратТоваровПоставщику(ДанныеЗаполнения) Экспорт
	
	ДокументОснование = ДанныеЗаполнения;
	
	Организация = ДанныеЗаполнения.Организация;
	Контрагент = ДанныеЗаполнения.Контрагент;
	
	Товары.Очистить();
	Для Каждого СтрокаТабличнойЧасти Из ДанныеЗаполнения.Товары Цикл
		НоваяСтрокаТабличнойЧасти = Товары.Добавить();	
		ЗаполнитьЗначенияСвойств(НоваяСтрокаТабличнойЧасти, СтрокаТабличнойЧасти);
		
		ПараметрыНоменклатуры = Справочники.Номенклатура.ПолучитьПараметрыНоменклатуры(СтрокаТабличнойЧасти.Номенклатура);
		ЗаполнитьЗначенияСвойств(НоваяСтрокаТабличнойЧасти, ПараметрыНоменклатуры);
		
		НоваяСтрокаТабличнойЧасти.КоличествоМест = НоваяСтрокаТабличнойЧасти.Количество;
		
		НоваяСтрокаТабличнойЧасти.МассаГрузаНетто = НоваяСтрокаТабличнойЧасти.Количество * НоваяСтрокаТабличнойЧасти.ВесЕдиницыНоменклатуры;
		НоваяСтрокаТабличнойЧасти.МассаГрузаБрутто = НоваяСтрокаТабличнойЧасти.МассаГрузаНетто + НоваяСтрокаТабличнойЧасти.КоличествоМест * НоваяСтрокаТабличнойЧасти.ВесУпаковки;
		
		НоваяСтрокаТабличнойЧасти.Сумма = СтрокаТабличнойЧасти.Всего;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

// Процедура - обработчик события ОбработкаЗаполнения объекта.
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	СтратегияЗаполнения = Новый Соответствие;
	СтратегияЗаполнения[Тип("ДокументСсылка.РеализацияТоваровУслуг")] = "ЗаполнитьПоРеализацииТоваровУслуг";
	СтратегияЗаполнения[Тип("ДокументСсылка.ВозвратТоваровПоставщику")] = "ЗаполнитьПоВозвратТоваровПоставщику";
	
	ЗаполнениеОбъектовБП.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения, СтратегияЗаполнения);
	
КонецПроцедуры

// Процедура - обработчик события ОбработкаПроверкиЗаполнения объекта.
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	ПроверяемыеРеквизиты.Добавить("Товары");
КонецПроцедуры // ОбработкаПроверкиЗаполнения()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура производит заполнение табличной части
//
Процедура ЗаполнитьТабличнуюЧасть(ДатаДокумента) Экспорт 
	
КонецПроцедуры 

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли