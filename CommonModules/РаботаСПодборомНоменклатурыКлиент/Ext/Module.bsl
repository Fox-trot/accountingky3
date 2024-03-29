﻿
#Область ПрограммныйИнтерфейс

#Область РаботаСПодбором

Процедура ОткрытьПодбор(ФормаВладелец, ИмяТабличнойЧасти, ВидДокумента) Экспорт
	
	ПараметрыПодбора = Новый Структура;
	
	ЗаполнитьЗначенияПараметровПодбора(ФормаВладелец, ИмяТабличнойЧасти, ПараметрыПодбора, ВидДокумента);
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяТабличнойЧасти", ИмяТабличнойЧасти);
	ОписаниеОповещенияПриЗакрытииПодбора = Новый ОписаниеОповещения("ПриЗакрытииПодбора", ЭтотОбъект, ДополнительныеПараметры);
	Если ВидДокумента = "Списание" Тогда
		ОткрытьФорму("Обработка.ПодборНоменклатуры.Форма.КорзинаСписания", 
		ПараметрыПодбора, ФормаВладелец, Истина, , , ОписаниеОповещенияПриЗакрытииПодбора, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	ИначеЕсли ВидДокумента = "Реализация" ИЛИ ВидДокумента = "СчетНаОплату" Тогда
		ОткрытьФорму("Обработка.ПодборНоменклатуры.Форма.КорзинаРеализации", 
		ПараметрыПодбора, ФормаВладелец, Истина, , , ОписаниеОповещенияПриЗакрытииПодбора, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);		
	ИначеЕсли ВидДокумента = "Поступление" Тогда
		ОткрытьФорму("Обработка.ПодборНоменклатуры.Форма.КорзинаПоступления", 
		ПараметрыПодбора, ФормаВладелец, Истина, , , ОписаниеОповещенияПриЗакрытииПодбора, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	ИначеЕсли ВидДокумента = "СписаниеМБПСклад" ИЛИ ВидДокумента = "СписаниеМБПМОЛ" Тогда
		ОткрытьФорму("Обработка.ПодборНоменклатуры.Форма.КорзинаДвиженияМБП", 
		ПараметрыПодбора, ФормаВладелец, Истина, , , ОписаниеОповещенияПриЗакрытииПодбора, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	ИначеЕсли ВидДокумента = "УстановкаЦен" Тогда
		ОткрытьФорму("Обработка.ПодборНоменклатуры.Форма.КорзинаУстановкаЦен", 
		ПараметрыПодбора, ФормаВладелец, Истина, , , ОписаниеОповещенияПриЗакрытииПодбора, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);	
	ИначеЕсли ВидДокумента = "СписаниеКонтрагент" Тогда
		ОткрытьФорму("Обработка.ПодборНоменклатуры.Форма.КорзинаСписанияКонтрагент", 
		ПараметрыПодбора, ФормаВладелец, Истина, , , ОписаниеОповещенияПриЗакрытииПодбора, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;	

КонецПроцедуры

// Процедура обработки результатов закрытия подбора
//
Процедура ПриЗакрытииПодбора(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(РезультатЗакрытия) = Тип("Структура") Тогда
		Если НЕ ПустаяСтрока(РезультатЗакрытия.АдресКорзиныВХранилище) Тогда
			ПараметрыОповещения = Новый Структура;
			ПараметрыОповещения.Вставить("АдресЗапасовВХранилище", РезультатЗакрытия.АдресКорзиныВХранилище);
			ПараметрыОповещения.Вставить("ИмяТабличнойЧасти", ДополнительныеПараметры.ИмяТабличнойЧасти);
			Оповестить("ПодборНоменклатурыПроизведен", ПараметрыОповещения, РезультатЗакрытия.УникальныйИдентификаторФормыВладельца);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры // ПриЗакрытииПодбора()

// Получение данных из форм-владельцев
//
// Параметры:
//   ФормаВладелец - форма из которой открывается подбор
//	 ИмяТабличнойЧасти - строка - наименование табличной части
// 	 ПараметрыПодбора - структура - структура для заполнения параметрами
//	 ВидДокумента - строка - наименование документа (произвольное, т.е. не полное наименование)
//
Процедура ЗаполнитьЗначенияПараметровПодбора(ФормаВладелец, ИмяТабличнойЧасти, ПараметрыПодбора, ВидДокумента)
	ПараметрыПодбора.Вставить("Организация", ФормаВладелец.ЭтотОбъект.Объект.Организация);
	ПараметрыПодбора.Вставить("Дата", ФормаВладелец.ДатаДокумента);
	ПараметрыПодбора.Вставить("УникальныйИдентификаторФормыВладельца", ФормаВладелец.УникальныйИдентификатор);
	
	Если ВидДокумента = "Списание" Тогда
		Если ТипЗнч(ФормаВладелец.ЭтотОбъект.Объект.Ссылка) = Тип("ДокументСсылка.ПеремещениеТоваров") Тогда
			Склад = ФормаВладелец.ЭтотОбъект.Объект.СкладОтправитель;	
		Иначе
			Склад = ФормаВладелец.ЭтотОбъект.Объект.Склад;
		КонецЕсли;
		ПараметрыПодбора.Вставить("Склад", Склад);
		
	ИначеЕсли ВидДокумента = "СписаниеМБПСклад" Тогда
		ПараметрыПодбора.Вставить("Склад", ФормаВладелец.ЭтотОбъект.Объект.Склад);
		ПараметрыПодбора.Вставить("МБПСклад", "");
		
	ИначеЕсли ВидДокумента = "СписаниеМБПМОЛ" Тогда
		ПараметрыПодбора.Вставить("ФизЛицо", ФормаВладелец.ЭтотОбъект.Объект.ФизЛицо);
		ПараметрыПодбора.Вставить("МБПМОЛ", "");
		
	ИначеЕсли ВидДокумента = "Реализация" Тогда
		ПараметрыПодбора.Вставить("Склад", ФормаВладелец.ЭтотОбъект.Объект.Склад);
		ПараметрыПодбора.Вставить("ДоговорКонтрагента", ФормаВладелец.ЭтотОбъект.Объект.ДоговорКонтрагента);
		ПараметрыПодбора.Вставить("ТочностьЦены", ФормаВладелец.ЭтотОбъект.Объект.ТочностьЦены);
		
	ИначеЕсли ВидДокумента = "Поступление" Тогда
		Если ТипЗнч(ФормаВладелец.ЭтотОбъект.Объект.Ссылка) = Тип("ДокументСсылка.ПоступлениеТоваровУслуг") Тогда
			ПараметрыПодбора.Вставить("ТочностьЦены", ФормаВладелец.ЭтотОбъект.Объект.ТочностьЦены);
		КонецЕсли;	
		
	ИначеЕсли ВидДокумента = "СчетНаОплату" Тогда
		ПараметрыПодбора.Вставить("Склад", ФормаВладелец.ЭтотОбъект.Объект.Склад);
		ПараметрыПодбора.Вставить("ДоговорКонтрагента", ФормаВладелец.ЭтотОбъект.Объект.ДоговорКонтрагента);
		ПараметрыПодбора.Вставить("ТочностьЦены", 2);
		
	ИначеЕсли ВидДокумента = "СписаниеКонтрагент" Тогда
		ПараметрыПодбора.Вставить("Склад", ФормаВладелец.ЭтотОбъект.Объект.Склад);
		ПараметрыПодбора.Вставить("Контрагент", ФормаВладелец.ЭтотОбъект.Объект.Контрагент);
		
	КонецЕсли;
		
	ЗаполнитьПараметрГруппаНоменклатуры(ФормаВладелец, ПараметрыПодбора);
	АдресПодобранных = РаботаСПодборомНоменклатурыВызовСервера.ПодготовитьТаблицуПодобранных(ФормаВладелец.ЭтотОбъект.Объект, ИмяТабличнойЧасти);
	ПараметрыПодбора.Вставить("АдресПодобранных", АдресПодобранных);
КонецПроцедуры

Процедура ЗаполнитьПараметрГруппаНоменклатуры(ФормаВладелец, ПараметрыПодбора)
	Перем ГруппаНоменклатуры;
	
	Если СтрНайти(ФормаВладелец.ИмяФормы, "УстановкаПлановыхЦен") > 0 Тогда
		ФормаВладелец.ЭтотОбъект.Объект.Свойство("ГруппаНоменклатуры", ГруппаНоменклатуры);
		ПараметрыПодбора.Вставить("ГруппаНоменклатуры", ГруппаНоменклатуры);
	КонецЕсли;
	
КонецПроцедуры

//Процедура ЗаполнитьСписокПодобранных(ФормаВладелец, ПараметрыПодбора, ИмяТабличнойЧасти)
//	СписокПодобранных = Новый СписокЗначений;
//	Для Каждого СтрокаТабличнойЧасти Из ФормаВладелец.Объект[ИмяТабличнойЧасти] Цикл 
//		СписокПодобранных.Добавить(СтрокаТабличнойЧасти.Номенклатура);
//	КонецЦикла;
//	
//	ПараметрыПодбора.Вставить("СписокПодобранных", СписокПодобранных);		
//КонецПроцедуры

// Конец Получение данных из форм-владельцев

#КонецОбласти

#КонецОбласти