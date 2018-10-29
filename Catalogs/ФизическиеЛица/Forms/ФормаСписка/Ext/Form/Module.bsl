﻿
#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
// В процедуре осуществляется
// - инициализация реквизитов формы,
// - установка параметров функциональных опций формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОтборОрганизация = Справочники.Организации.ОрганизацияПоУмолчанию();
	УстановитьПараметрыДинамическихСписков();
	
	// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов
	МожноРедактировать = ПравоДоступа("Редактирование", Метаданные.Справочники.ФизическиеЛица);
	Элементы.СписокКонтекстноеМенюИзменитьВыделенные.Видимость = МожноРедактировать;
	// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры // ПриСозданииНаСервере()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	ПатаметрыДопИнформации = Новый Структура;
	ПатаметрыДопИнформации.Вставить("ИнформацияФизЛицоДатаПриема","");
	ПатаметрыДопИнформации.Вставить("ИнформацияФизЛицоДатаУвольнения","");
	ПатаметрыДопИнформации.Вставить("ИнформацияФизЛицоДолжность","");
	ПатаметрыДопИнформации.Вставить("ИнформацияФизЛицоПодразделение","");
	ПатаметрыДопИнформации.Вставить("ИнформацияФизЛицоТелефон", "");

	ДанныеТекущейСтроки = Элементы.Список.ТекущиеДанные;
	
	Если ДанныеТекущейСтроки = Неопределено
		Или ДанныеТекущейСтроки.ЭтоГруппа Тогда 
		
		ЗаполнитьЗначенияСвойств(ЭтаФорма, ПатаметрыДопИнформации);
		Возврат;
	КонецЕсли;	
	
	// Телефон
	ТелефонРабочийФизическиеЛица = КонтактнаяИнформацияОбъекта(ДанныеТекущейСтроки.Ссылка, 
		ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.ТелефонРабочийФизическиеЛица"));
	
	ПатаметрыДопИнформации.ИнформацияФизЛицоТелефон = ТелефонРабочийФизическиеЛица;
	
	ИнформационнаяПанельЗаполнить(ДанныеТекущейСтроки.Ссылка, ПатаметрыДопИнформации);
	
КонецПроцедуры

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ИнформационнаяПанельЗаполнить(ФизЛицо,ПатаметрыДопИнформации)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СотрудникиСрезПоследних.Период
		|ПОМЕСТИТЬ ВременнаяТаблицаУволен
		|ИЗ
		|	РегистрСведений.Сотрудники.СрезПоследних(
		|			,
		|			ФизЛицо = &ФизЛицо
		|				И ВидСобытия = ЗНАЧЕНИЕ(Перечисление.ВидыКадровыхСобытий.Увольнение)) КАК СотрудникиСрезПоследних
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СотрудникиСрезПоследних.Период
		|ПОМЕСТИТЬ ВременнаяТаблицаПринят
		|ИЗ
		|	РегистрСведений.Сотрудники.СрезПоследних(
		|			,
		|			ФизЛицо = &ФизЛицо
		|				И ВидСобытия = ЗНАЧЕНИЕ(Перечисление.ВидыКадровыхСобытий.Прием)) КАК СотрудникиСрезПоследних
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СотрудникиСрезПоследних.Должность КАК ИнформацияФизЛицоДолжность,
		|	СотрудникиСрезПоследних.Подразделение КАК ИнформацияФизЛицоПодразделение,
		|	ВременнаяТаблицаУволен.Период КАК ИнформацияФизЛицоДатаУвольнения,
		|	ВременнаяТаблицаПринят.Период КАК ИнформацияФизЛицоДатаПриема
		|ИЗ
		|	РегистрСведений.Сотрудники.СрезПоследних(, ФизЛицо = &ФизЛицо) КАК СотрудникиСрезПоследних
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВременнаяТаблицаУволен КАК ВременнаяТаблицаУволен
		|		ПО (ИСТИНА)
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВременнаяТаблицаПринят КАК ВременнаяТаблицаПринят
		|		ПО (ИСТИНА)";
	Запрос.УстановитьПараметр("ФизЛицо", ФизЛицо);
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	Если Выборка.Следующий() Тогда 
		ЗаполнитьЗначенияСвойств(ПатаметрыДопИнформации,Выборка);
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтаФорма, ПатаметрыДопИнформации);
КонецПроцедуры

&НаСервере
// Процедура устанавливает значения параметров динамических списков 
//
Процедура УстановитьПараметрыДинамическихСписков()
	Список.Параметры.УстановитьЗначениеПараметра("Организация", ОтборОрганизация);
КонецПроцедуры // УстановитьПараметрыДинамическихСписков()

&НаСервереБезКонтекста
// Получить значение определенного вида контактной информации у объекта.
//
// Параметры:
//     Ссылка                  - ЛюбаяСсылка - ссылка на объект-владелец контактной информации (организация,
//                                             контрагент, партнер и т.д.).
//     ВидКонтактнойИнформации - СправочникСсылка.ВидыКонтактнойИнформации - параметры обработки.
//
// Возвращаемое значение:
//     Строка - строковое представление значения.
//
Функция КонтактнаяИнформацияОбъекта(Ссылка, ВидКонтактнойИнформации, Дата = Неопределено)
	Возврат УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(Ссылка, ВидКонтактнойИнформации, Дата)	
КонецФункции

#КонецОбласти

#Область МеткиОтборов

&НаКлиенте
Процедура СвернутьРазвернутьПанельОтборов(Элемент)
	
	НовоеЗначениеВидимость = НЕ Элементы.ФильтрыНастройкиИДопИнфо.Видимость;
	РаботаСОтборамиКлиент.СвернутьРазвернутьПанельОтборов(ЭтотОбъект, НовоеЗначениеВидимость);
		
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов
&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти
