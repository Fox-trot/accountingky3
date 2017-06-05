﻿#Область ОбработчикиСлужебные

// Получает набор данных с сервера для процедуры ДатаПриИзменении.
//
&НаСервере
Функция ПолучитьДанныеДатаПриИзменении(ДатаПередИзменением)
	РазностьДат = БухгалтерскийУчетСервер.ПроверитьНомерДокумента(Объект.Ссылка, Объект.Дата, ДатаПередИзменением);
	
	СтруктураДанные = Новый Структура;
	СтруктураДанные.Вставить("РазностьДат",	РазностьДат);
	
	Возврат СтруктураДанные;
КонецФункции // ПолучитьДанныеДатаПриИзменении()

#КонецОбласти

#Область УправлениеВнешнимВидом

// Видимость и доступность всех элементов формы
//
Процедура УстановитьВидимостьДоступностьЭлементов()
		
	Элементы.Город.Видимость 			= Объект.ОдинГород;
	
	Если НЕ Объект.ОднаСтрана Тогда
		Элементы.ОдинГород.Доступность 	= Ложь;
	Иначе		
		Элементы.ОдинГород.Доступность 	= Истина;		
	КонецЕсли;
	
	Элементы.ТарифыСтрана.Видимость 	= НЕ Объект.ОднаСтрана;
	Элементы.ТарифыГород.Видимость 		= НЕ Объект.ОдинГород;
	
	
КонецПроцедуры // УстановитьВидимостьДоступностьЭлементов()  

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	// Установка реквизитов формы.
	ДатаДокумента = Объект.Дата;
	Если НЕ ЗначениеЗаполнено(ДатаДокумента) Тогда
		ДатаДокумента = ТекущаяДата();
	КонецЕсли;
	
	УстановитьВидимостьДоступностьЭлементов();
	
	БухгалтерскийУчетКлиентСервер.УстановитьКартинкуДляКомментария(Элементы.СтраницаДополнительно, Объект.Комментарий);
	
	// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
КонецПроцедуры

// Процедура - обработчик события ПриЧтенииНаСервере.
//
&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменений
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменений
	
КонецПроцедуры // ПриЧтенииНаСервере()

#КонецОбласти

#Область ОбработчикиРеквизитовШапки

// Процедура - обработчик события ПриИзменении поля ввода Дата.
// В процедуре определяется ситуация, когда при изменении своей даты документ 
// оказывается в другом периоде нумерации документов, и в этом случае
// присваивает документу новый уникальный номер.
// Переопределяет соответствующий параметр формы.
//
&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	// Обработка события изменения даты.
	ДатаПередИзменением = ДатаДокумента;
	ДатаДокумента = Объект.Дата;
	Если Объект.Дата <> ДатаПередИзменением Тогда
		СтруктураДанные = ПолучитьДанныеДатаПриИзменении(ДатаПередИзменением);
		Если СтруктураДанные.РазностьДат <> 0 Тогда
			Объект.Номер = "";
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	// Обработка события изменения организации.
	Объект.Номер = "";
	БухгалтерскийУчетСервер.ПроверитьСуществованиеУчетнойПолитикиОрганизаций(ДатаДокумента, Объект.Организация);
КонецПроцедуры

&НаКлиенте
Процедура КомментарийПриИзменении(Элемент)
	БухгалтерскийУчетКлиентСервер.УстановитьКартинкуДляКомментария(Элементы.СтраницаДополнительно, Объект.Комментарий);
КонецПроцедуры

&НаКлиенте
Процедура ОднаСтранаПриИзменении(Элемент)
	Если НЕ Объект.ОднаСтрана Тогда
		Объект.ОдинГород 	= Ложь;
		
	КонецЕсли;
	
	УстановитьВидимостьДоступностьЭлементов()
КонецПроцедуры

&НаКлиенте
Процедура ОдинГородПриИзменении(Элемент)
	УстановитьВидимостьДоступностьЭлементов()
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиТабличныхЧастей

&НаКлиенте
Процедура ТарифыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если НоваяСтрока Тогда
		СТЧ 		= Элемент.ТекущиеДанные;	
	    СТЧ.Страна	= Объект.Страна;
		СТЧ.Город   = Объект.Город;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
&НаКлиенте
Процедура Подключаемый_ВыполнитьНазначаемуюКоманду(Команда)
	
	Если Не ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьНазначаемуюКомандуНаКлиенте(ЭтотОбъект, Команда.Имя) Тогда
		РезультатВыполнения = Неопределено;
		ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(Команда.Имя, РезультатВыполнения);
		ДополнительныеОтчетыИОбработкиКлиент.ПоказатьРезультатВыполненияКоманды(ЭтотОбъект, РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
	
	ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтотОбъект, ИмяЭлемента, РезультатВыполнения);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

#КонецОбласти
