﻿
#Область СлужебныйПрограммныйИнтерфейс

// Возвращает типы ссылок общих данных, сопоставляемых по полям поиска.
//
// Возвращаемое значение:
//   Соответствие - коллекция типов ссылок.
//
Функция ТипыСопоставляемыхОбщихДанныхПоПолямПоиска() Экспорт
	
	Типы = Новый Соответствие;
	Для Каждого ОбъектМетаданных Из ВыгрузкаЗагрузкаДанныхСлужебныйСобытия.ПолучитьТипыОбщихДанныхПоддерживающиеСопоставлениеСсылокПриЗагрузке() Цикл
		Типы.Вставить(ОбъектМетаданных.СтандартныеРеквизиты.Ссылка.Тип.Типы()[0], Истина);
	КонецЦикла;
	
	Возврат Типы;
	
КонецФункции

// Возвращает типы ссылок общих данных, сопоставляемых по предопределенному имени.
//
// Возвращаемое значение:
//   Соответствие - коллекция типов ссылок.
//
Функция ТипыСопоставляемыхОбщихДанныхПоПредопределенномуИмени() Экспорт
	
	Типы = Новый Соответствие;
	
	РазделенныеОбъектыМетаданных = МиграцияПриложенийПовтИсп.МодельДанныхОбласти();
	РазрешенныеОбщиеДанные = ВыгрузкаЗагрузкаДанныхСлужебныйСобытия.ПолучитьТипыОбщихДанныхПоддерживающиеСопоставлениеСсылокПриЗагрузке();
	
	Для Каждого ВидМетаданных Из ВидыМетаданныхСПредопределенными() Цикл
		Для Каждого ОбъектМетаданных Из ВидМетаданных Цикл
			Если РазделенныеОбъектыМетаданных[ОбъектМетаданных] <> Неопределено Тогда
				Продолжить;
			КонецЕсли;
			Если РазрешенныеОбщиеДанные.Найти(ОбъектМетаданных) <> Неопределено Тогда
				Продолжить;
			КонецЕсли;
			Если ОбъектМетаданных.ПолучитьИменаПредопределенных().Количество() <> 0 Тогда
				Типы.Вставить(ОбъектМетаданных.СтандартныеРеквизиты.Ссылка.Тип.Типы()[0], Истина);
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Возврат Типы;
	
КонецФункции

// Возвращает коллекцию разделенных метаданных, являющихся данными.
//
// Возвращаемое значение:
//   Соответствие - коллекция объектов типа ОбъектМетаданных.
//
Функция МодельДанныхОбласти() Экспорт
	
	МодельДанныхОбласти = Новый Соответствие;
	
	НеИспользовать  = Метаданные.СвойстваОбъектов.ИспользованиеОбщегоРеквизита.НеИспользовать;
	Для Каждого Состав Из Метаданные.ОбщиеРеквизиты.ОбластьДанныхОсновныеДанные.Состав Цикл
		ОбъектМетаданных = Состав.Метаданные;
		Если Состав.Использование <> НеИспользовать 
			И Не Метаданные.РегламентныеЗадания.Содержит(ОбъектМетаданных)
			И Не Метаданные.ВнешниеИсточникиДанных.Содержит(ОбъектМетаданных)
			И Не Метаданные.ПланыОбмена.Содержит(ОбъектМетаданных) Тогда
			МодельДанныхОбласти.Вставить(ОбъектМетаданных, Истина);
			Если Метаданные.РегистрыРасчета.Содержит(ОбъектМетаданных) Тогда
				Для Каждого Перерасчет Из ОбъектМетаданных.Перерасчеты Цикл
					МодельДанныхОбласти.Вставить(Перерасчет, Истина);
				КонецЦикла; 
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Использовать  = Метаданные.СвойстваОбъектов.ИспользованиеОбщегоРеквизита.Использовать;
	Для Каждого Состав Из Метаданные.ОбщиеРеквизиты.ОбластьДанныхВспомогательныеДанные.Состав Цикл
		ОбъектМетаданных = Состав.Метаданные;
		Если Состав.Использование = Использовать 
			И Не Метаданные.РегламентныеЗадания.Содержит(ОбъектМетаданных)
			И Не Метаданные.ВнешниеИсточникиДанных.Содержит(ОбъектМетаданных)
			И Не Метаданные.ПланыОбмена.Содержит(ОбъектМетаданных) Тогда
			МодельДанныхОбласти.Вставить(ОбъектМетаданных, Истина);
			Если Метаданные.РегистрыРасчета.Содержит(ОбъектМетаданных) Тогда
				Для Каждого Перерасчет Из ОбъектМетаданных.Перерасчеты Цикл
					МодельДанныхОбласти.Вставить(Перерасчет, Истина);
				КонецЦикла; 
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого Последовательность Из Метаданные.Последовательности Цикл
		Для Каждого ОбъектМетаданных Из Последовательность.Документы Цикл
			Если МодельДанныхОбласти.Получить(ОбъектМетаданных) <> Неопределено Тогда
				МодельДанныхОбласти.Вставить(Последовательность, Истина);
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Возврат МодельДанныхОбласти;
	
КонецФункции


// Возвращает загружаемые объекты метаданных, которые используются в выгрузке data_dump.zip.
//
// Возвращаемое значение:
//   Соответствие - коллекция объектов метаданных.
//
Функция ВыгружаемыеОбъекты() Экспорт
	
	ВыгружаемыеОбъекты = МиграцияПриложенийПовтИсп.МодельДанныхОбласти();
	
	Для Каждого ОбъектМетаданных Из ВыгрузкаЗагрузкаДанныхСлужебныйСобытия.ПолучитьТипыИсключаемыеИзВыгрузкиЗагрузки() Цикл
		ВыгружаемыеОбъекты.Удалить(ОбъектМетаданных);
	КонецЦикла;
	
	Возврат ВыгружаемыеОбъекты;
	
КонецФункции

// Возвращает коллекцию запрещенных типов ссылок.
//
// Возвращаемое значение:
//   Соответствие - коллекция типов ссылок.
//
Функция ЗапрещенныеТипыОбщихДанных() Экспорт
	
	Типы = Новый Соответствие;
	
	РазделенныеОбъектыМетаданных = МиграцияПриложенийПовтИсп.МодельДанныхОбласти();
	РазрешенныеОбщиеДанные = ВыгрузкаЗагрузкаДанныхСлужебныйСобытия.ПолучитьТипыОбщихДанныхПоддерживающиеСопоставлениеСсылокПриЗагрузке();
	ВидыМетаданныхСПредопределенными = ВидыМетаданныхСПредопределенными();
	
	ВидыМетаданных = Новый Массив;
	ВидыМетаданных.Добавить(Метаданные.Справочники);
	ВидыМетаданных.Добавить(Метаданные.ПланыВидовХарактеристик);
	ВидыМетаданных.Добавить(Метаданные.ПланыСчетов);
	ВидыМетаданных.Добавить(Метаданные.ПланыВидовРасчета);
	ВидыМетаданных.Добавить(Метаданные.Документы);
	ВидыМетаданных.Добавить(Метаданные.БизнесПроцессы);
	ВидыМетаданных.Добавить(Метаданные.Задачи);
	
	Для Каждого ВидМетаданных Из ВидыМетаданных Цикл
		ИмеютПредопределенные = ВидыМетаданныхСПредопределенными.Найти(ВидМетаданных) <> Неопределено;
		Для Каждого ОбъектМетаданных Из ВидМетаданных Цикл
			Если РазделенныеОбъектыМетаданных[ОбъектМетаданных] <> Неопределено Тогда
				Продолжить;
			КонецЕсли;
			Если РазрешенныеОбщиеДанные.Найти(ОбъектМетаданных) <> Неопределено Тогда
				Продолжить;
			КонецЕсли;
			Если Не ИмеютПредопределенные Или ОбъектМетаданных.ПолучитьИменаПредопределенных().Количество() = 0 Тогда
				Типы.Вставить(ОбъектМетаданных.СтандартныеРеквизиты.Ссылка.Тип.Типы()[0], Истина);
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Возврат Типы;
	
КонецФункции

// Возвращает коллекцию типов ссылок объектов, которые разделены независимо и совместно.
//
// Возвращаемое значение:
//   Соответствие - коллекция типов ссылок.
//
Функция ТипыПересоздаваемыхСсылок() Экспорт
	
	Типы = Новый Соответствие;
	
	Для Каждого ЭлементСостава Из Метаданные.ОбщиеРеквизиты.ОбластьДанныхВспомогательныеДанные.Состав Цикл
		Если ЭлементСостава.Использование = Метаданные.СвойстваОбъектов.ИспользованиеОбщегоРеквизита.Использовать Тогда
			
			Если Метаданные.Справочники.Содержит(ЭлементСостава.Метаданные)
				Или Метаданные.ПланыВидовХарактеристик.Содержит(ЭлементСостава.Метаданные)
				Или Метаданные.ПланыОбмена.Содержит(ЭлементСостава.Метаданные)
				Или Метаданные.Документы.Содержит(ЭлементСостава.Метаданные)
				Или Метаданные.ПланыСчетов.Содержит(ЭлементСостава.Метаданные)
				Или Метаданные.ПланыВидовРасчета.Содержит(ЭлементСостава.Метаданные)
				Или Метаданные.БизнесПроцессы.Содержит(ЭлементСостава.Метаданные)
				Или Метаданные.Задачи.Содержит(ЭлементСостава.Метаданные) Тогда
				
				Типы.Вставить(ЭлементСостава.Метаданные.СтандартныеРеквизиты.Ссылка.Тип.Типы()[0], Истина);
				
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Типы;
	
КонецФункции

// Возвращает коллекцию совместно разделенных объектов метаданных.
//
// Возвращаемое значение:
//   Соответствие - коллекция объектов метаданных.
//
Функция СовместноИспользуемыеОбъектыМетаданных() Экспорт
	
	Объекты = Новый Соответствие;
	
	Для Каждого ЭлементСостава Из Метаданные.ОбщиеРеквизиты.ОбластьДанныхВспомогательныеДанные.Состав Цикл
		Если ЭлементСостава.Использование = Метаданные.СвойстваОбъектов.ИспользованиеОбщегоРеквизита.Использовать Тогда
			Объекты.Вставить(ЭлементСостава.Метаданные, Истина);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Объекты;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает виды метаданных, которые могут иметь предопределенные элементы.
//
// Возвращаемое значение:
//   Массив - массив видов объектов.
//
Функция ВидыМетаданныхСПредопределенными()
	
	ВидыМетаданных = Новый Массив;
	ВидыМетаданных.Добавить(Метаданные.Справочники);
	ВидыМетаданных.Добавить(Метаданные.ПланыВидовХарактеристик);
	ВидыМетаданных.Добавить(Метаданные.ПланыСчетов);
	ВидыМетаданных.Добавить(Метаданные.ПланыВидовРасчета);
	
	Возврат ВидыМетаданных;
	
КонецФункции

#КонецОбласти
