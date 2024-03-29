﻿
#Область ПрограммныйИнтерфейс

#Область ОтборыПериода

Процедура УстановитьОтборПоПериоду(СписокОтбор, ДатаНачала, ДатаОкончания, ИмяПоляОтбора = "Дата") Экспорт
	
	// Отбор на список по периоду
	ГруппаОтборПоПериоду = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(
		СписокОтбор.Элементы,
		"Период",
		ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ);
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(
		ГруппаОтборПоПериоду,
		ИмяПоляОтбора,
		ВидСравненияКомпоновкиДанных.БольшеИлиРавно,
		ДатаНачала,
		"ДатаНачала",
		ЗначениеЗаполнено(ДатаНачала));
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(
		ГруппаОтборПоПериоду,
		ИмяПоляОтбора,
		ВидСравненияКомпоновкиДанных.МеньшеИлиРавно,
		ДатаОкончания,
		"ДатаОкончания",
		ЗначениеЗаполнено(ДатаОкончания));
		
КонецПроцедуры
	
Функция ОбновитьПредставлениеПериода(Период) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Период) ИЛИ (НЕ ЗначениеЗаполнено(Период.ДатаНачала) И НЕ ЗначениеЗаполнено(Период.ДатаОкончания)) Тогда
		ПредставлениеПериода = НСтр("ru = 'Период: за все время'");
	Иначе
		ДатаОкончанияПериода = ?(ЗначениеЗаполнено(Период.ДатаОкончания), КонецДня(Период.ДатаОкончания), Период.ДатаОкончания);
		Если ДатаОкончанияПериода < Период.ДатаНачала Тогда
			#Если Клиент Тогда
			БухгалтерскийУчетКлиент.СообщитьОбОшибке(Неопределено, НСтр("ru = 'Выбрана дата окончания периода, которая меньше даты начала.'"));
			#КонецЕсли
			ПредставлениеПериода = НСтр("ru = 'с '")+Формат(Период.ДатаНачала, "ДЛФ=D");
		Иначе
			ПредставлениеПериода = НСтр("ru = 'за '")+НРег(ПредставлениеПериода(Период.ДатаНачала, ДатаОкончанияПериода));
		КонецЕсли; 
			КонецЕсли;
	
	Возврат ПредставлениеПериода;
	
КонецФункции

#КонецОбласти

#Область ПроцедурыИФункцииРаботыСдинамическимиСпиками

// Процедура устанавливает отбор у динамического списка на равенство.
//
Процедура УстановитьОтборУДинамическогоСпискаНаРавенство(Отбор, ЛевоеЗначение, ПравоеЗначение) Экспорт
	
	ЭлементОтбора = Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение	 = ЛевоеЗначение;
	ЭлементОтбора.ВидСравнения	 = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.ПравоеЗначение = ПравоеЗначение;
	ЭлементОтбора.Использование  = Истина;
	
КонецПроцедуры // УстановитьОтборДляДинамическогоСписка()

// Устанавливает элемент отбор динамического списка
//
// Параметры:
//   Список			- обрабатываемый динамический список,
//   ИмяПоля			- имя поля компоновки, отбор по которому нужно установить,
//   ВидСравнения		- вид сравнения отбора, по умолчанию - Равно,
//   ПравоеЗначение	- значение отбора
//
Процедура УстановитьЭлементОтбораСписка(Список, ИмяПоля, ПравоеЗначение, Использование = Истина, ВидСравнения = Неопределено) Экспорт
	
	НаборЭлементов = Список.КомпоновщикНастроек.Настройки.Отбор;
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(НаборЭлементов,ИмяПоля,ПравоеЗначение,ВидСравнения,,Использование);
	
КонецПроцедуры // УстановитьЭлементОтбораСписка()

// Удаляет элемент отбора динамического списка
//
// Параметры:
//   Список  - обрабатываемый динамический список,
//   ИмяПоля - имя поля компоновки, отбор по которому нужно удалить
//
Процедура УдалитьЭлементОтбораСписка(Список, ИмяПоля) Экспорт
	
	НаборЭлементов = Список.КомпоновщикНастроек.Настройки.Отбор;
	ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(НаборЭлементов,ИмяПоля);
	
КонецПроцедуры // УдалитьЭлементОтбораСписка()

// Изменяет элемент отбора динамического списка
//
// Параметры:
//   Список         - обрабатываемый динамический список
//   ИмяПоля        - имя поля компоновки, отбор по которому нужно установить
//   ПравоеЗначение - значение отбора, по умолчанию - Неопределено
//   Использование  - признак использования отбора, по умолчанию - Ложь
//   ВидСравнения   - вид сравнения отбора, по умолчанию - Равно
//
Процедура ИзменитьЭлементОтбораСписка(Список, ИмяПоля, ПравоеЗначение = Неопределено, Использование = Ложь, ВидСравнения = Неопределено) Экспорт
	
	ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(
		Список.КомпоновщикНастроек.Настройки.Отбор, 
		ИмяПоля);
		
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
		Список.КомпоновщикНастроек.Настройки.Отбор, 
		ИмяПоля, 
		ПравоеЗначение, 
		ВидСравнения, 
		РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ, 
		Использование); 
		
КонецПроцедуры 

// Функция считывает значения элементов отбора динамического списка
//
Функция ПрочитатьЗначенияОтбораДинамическогоСписка(Список) Экспорт
	
	ДанныеЗаполнения = Новый Структура;
	
	Если ТипЗнч(Список) = Тип("ДинамическийСписок") Тогда
		
		Для каждого ЭлементОтбораДинамическогоСписка Из Список.Отбор.Элементы Цикл
			
			ДанныеЗаполнения.Вставить(ЭлементОтбораДинамическогоСписка.ЛевоеЗначение, ЭлементОтбораДинамическогоСписка.ПравоеЗначение);
			
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат ДанныеЗаполнения;
	
КонецФункции // ПрочитатьЗначенияОтбораДинамическогоСписка()

#КонецОбласти

#КонецОбласти



