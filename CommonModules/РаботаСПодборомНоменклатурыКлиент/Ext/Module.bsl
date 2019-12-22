﻿
#Область ПрограммныйИнтерфейс

#Область РаботаСПодбором

Процедура ОткрытьПодбор(ФормаВладелец, ИмяТабличнойЧасти, ТипДокумента) Экспорт
	
	ПараметрыПодбора = Новый Структура;
	
	ЗаполнитьЗначенияПараметровПодбора(ФормаВладелец, ИмяТабличнойЧасти, ПараметрыПодбора, ТипДокумента);
	
	ОписаниеОповещенияПриЗакрытииПодбора = Новый ОписаниеОповещения("ПриЗакрытииПодбора", ЭтотОбъект);
	Если ТипДокумента = "Списание" Тогда
		ОткрытьФорму("Обработка.ПодборНоменклатуры.Форма.КорзинаСписания", 
		ПараметрыПодбора, ФормаВладелец, Истина, , , ОписаниеОповещенияПриЗакрытииПодбора, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	ИначеЕсли ТипДокумента = "Реализация" Тогда
		ОткрытьФорму("Обработка.ПодборНоменклатуры.Форма.КорзинаРеализации", 
		ПараметрыПодбора, ФормаВладелец, Истина, , , ОписаниеОповещенияПриЗакрытииПодбора, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);		
	ИначеЕсли ТипДокумента = "Поступление" Тогда
		ОткрытьФорму("Обработка.ПодборНоменклатуры.Форма.КорзинаПоступления", 
		ПараметрыПодбора, ФормаВладелец, Истина, , , ОписаниеОповещенияПриЗакрытииПодбора, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	ИначеЕсли ТипДокумента = "СписаниеМБПСклад" ИЛИ ТипДокумента = "СписаниеМБПМОЛ" Тогда
		ОткрытьФорму("Обработка.ПодборНоменклатуры.Форма.КорзинаДвиженияМБП", 
		ПараметрыПодбора, ФормаВладелец, Истина, , , ОписаниеОповещенияПриЗакрытииПодбора, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	ИначеЕсли ТипДокумента = "УстановкаЦен" Тогда
		ОткрытьФорму("Обработка.ПодборНоменклатуры.Форма.КорзинаУстановкаЦен", 
		ПараметрыПодбора, ФормаВладелец, Истина, , , ОписаниеОповещенияПриЗакрытииПодбора, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);	
	КонецЕсли;	

КонецПроцедуры

// Процедура обработки результатов закрытия подбора
//
Процедура ПриЗакрытииПодбора(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(РезультатЗакрытия) = Тип("Структура") Тогда
		Если НЕ ПустаяСтрока(РезультатЗакрытия.АдресКорзиныВХранилище) Тогда
			Оповестить("ПодборНоменклатурыПроизведен", РезультатЗакрытия.АдресКорзиныВХранилище, РезультатЗакрытия.УникальныйИдентификаторФормыВладельца);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры // ПриЗакрытииПодбора()

// Получение данных из форм-владельцев
Процедура ЗаполнитьЗначенияПараметровПодбора(ФормаВладелец, ИмяТабличнойЧасти, ПараметрыПодбора, ТипДокумента)
	ПараметрыПодбора.Вставить("Организация", ФормаВладелец.ЭтотОбъект.Объект.Организация);
	ПараметрыПодбора.Вставить("Дата", ФормаВладелец.ДатаДокумента);
	ПараметрыПодбора.Вставить("УникальныйИдентификаторФормыВладельца", ФормаВладелец.УникальныйИдентификатор);
	
	Если ТипДокумента = "Списание" Тогда
		Если ТипЗнч(ФормаВладелец.ЭтотОбъект.Объект.Ссылка) = Тип("ДокументСсылка.ПеремещениеТоваров") Тогда
			Склад = ФормаВладелец.ЭтотОбъект.Объект.СкладОтправитель;	
		Иначе
			Склад = ФормаВладелец.ЭтотОбъект.Объект.Склад;
		КонецЕсли;
		ПараметрыПодбора.Вставить("Склад", Склад);
		
	ИначеЕсли ТипДокумента = "СписаниеМБПСклад" Тогда
		ПараметрыПодбора.Вставить("Склад", ФормаВладелец.ЭтотОбъект.Объект.Склад);
		ПараметрыПодбора.Вставить("МБПСклад", "");
		
	ИначеЕсли ТипДокумента = "СписаниеМБПМОЛ" Тогда
		ПараметрыПодбора.Вставить("ФизЛицо", ФормаВладелец.ЭтотОбъект.Объект.ФизЛицо);
		ПараметрыПодбора.Вставить("МБПМОЛ", "");
		
	ИначеЕсли ТипДокумента = "Реализация" Тогда
		ПараметрыПодбора.Вставить("Склад", ФормаВладелец.ЭтотОбъект.Объект.Склад);
		ПараметрыПодбора.Вставить("ДоговорКонтрагента", ФормаВладелец.ЭтотОбъект.Объект.ДоговорКонтрагента);
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