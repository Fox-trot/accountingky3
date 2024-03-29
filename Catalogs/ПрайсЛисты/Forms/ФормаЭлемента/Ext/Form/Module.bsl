﻿
#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
// В процедуре осуществляется
// - инициализация реквизитов формы,
// - установка параметров функциональных опций формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		Объект.Валюта = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
		
	КонецЕсли;
	
	Если Объект.ПредставлениеНоменклатуры.НайтиСтроки(Новый Структура("Использование", Истина)).Количество() = 0 Тогда
		
		ТаблицаПредставлений = Неопределено;
		Справочники.ПрайсЛисты.ДоступныеПоляНоменклатуры(ТаблицаПредставлений);
		Объект.ПредставлениеНоменклатуры.Загрузить(ТаблицаПредставлений);
		
	КонецЕсли;
	
	Если ПустаяСтрока(Объект.Наименование) Тогда
		
		Объект.Наименование = НСтр("ru = 'Прайс-лист'");
		
	КонецЕсли;
	
	КэшЗначений = Новый Структура;	
	КэшЗначений.Вставить("Полотно", 				Перечисления.ВариантыПечатиПрайсЛиста.Полотно);
	КэшЗначений.Вставить("ДвеКолонки",				Перечисления.ВариантыПечатиПрайсЛиста.ДвеКолонки);
	КэшЗначений.Вставить("Диафильм",				Перечисления.ВариантыПечатиПрайсЛиста.Диафильм);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Организация", 		"Доступность", Объект.ВыводитьКонтактнуюИнформацию);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ДатаФормирования",	"Доступность", Объект.ВыводитьДатуФормирования);
	
КонецПроцедуры

// Процедура - обработчик события ПриОткрытии.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УправлениеСвойствамиЭлементовФормы();
	ЗаполнитьПредставлениеНоменклатуры();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если Объект.ПечатьПрайсЛиста = КэшЗначений.ДвеКолонки Тогда
		
		УдалитьИзбыточныеСтроки(Отказ);
		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.ТипЦены) 
		И (Объект.ПечатьПрайсЛиста = КэшЗначений.Диафильм ИЛИ Объект.ПечатьПрайсЛиста = КэшЗначений.ДвеКолонки) Тогда
		
		ТекстСообщения = НСтр("ru = 'Необходимо заполнить поле ""Тип цены"".'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,, "Объект.ТипЦены",,Отказ)	
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Процедура - обработчик события ПриИзменении поля ввода ПечатьПрайсЛиста.
//
&НаКлиенте
Процедура ПечатьПрайсЛистаПриИзменении(Элемент)
	
	ИзменитьВариантПечатиПрайсЛиста();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоставРеквизитовНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыОткрытияФормы = Новый Структура;
	ПараметрыОткрытияФормы.Вставить("ПредставлениеНоменклатуры", Объект.ПредставлениеНоменклатуры);
	ПараметрыОткрытияФормы.Вставить("ПечатьПрайсЛиста", Объект.ПечатьПрайсЛиста);
	
	ПараметрыОткрытияФормы.Вставить("КоличествоКолонок", Объект.КоличествоКолонок);
	ПараметрыОткрытияФормы.Вставить("КартинкаШирина", Объект.КартинкаШирина);
	ПараметрыОткрытияФормы.Вставить("КартинкаВысота", Объект.КартинкаВысота);
	ПараметрыОткрытияФормы.Вставить("ИзменятьРазмерПропорционально", Объект.ИзменятьРазмерПропорционально);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("СоставРеквизитовПослеРедактирования", ЭтотОбъект);
	Если Объект.ПечатьПрайсЛиста = КэшЗначений.Полотно Тогда
		
		ОткрытьФорму("Справочник.ПрайсЛисты.Форма.ФормаСоставРеквизитов", ПараметрыОткрытияФормы, ЭтотОбъект, , , , ОписаниеОповещения);
		
	ИначеЕсли Объект.ПечатьПрайсЛиста = КэшЗначений.ДвеКолонки 
		ИЛИ Объект.ПечатьПрайсЛиста = КэшЗначений.Диафильм Тогда
		
		ОткрытьФорму("Справочник.ПрайсЛисты.Форма.ФормаСоставРеквизитовДвеКолонки", ПараметрыОткрытияФормы, ЭтотОбъект, , , , ОписаниеОповещения);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиИнтерактивныхДействий

&НаКлиенте
Процедура СоставРеквизитовПослеРедактирования(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(РезультатЗакрытия) = Тип("Структура") Тогда
		
		Если РезультатЗакрытия.РезультатЗакрытия = КодВозвратаДиалога.ОК Тогда
			
			Объект.ПредставлениеНоменклатуры.Очистить();
			Для каждого Строка Из РезультатЗакрытия.ПредставлениеНоменклатуры Цикл
				
				ЗаполнитьЗначенияСвойств(Объект.ПредставлениеНоменклатуры.Добавить(), Строка);
				
			КонецЦикла;
			
			Объект.КоличествоКолонок = РезультатЗакрытия.КоличествоКолонок;
			Объект.КартинкаШирина = РезультатЗакрытия.КартинкаШирина;
			Объект.КартинкаВысота = РезультатЗакрытия.КартинкаВысота;
			Объект.ИзменятьРазмерПропорционально = РезультатЗакрытия.ИзменятьРазмерПропорционально;
			
			ЗаполнитьПредставлениеНоменклатуры();
			
			Модифицированность = Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ВыводитьКонтактнуюИнформацию.
//
&НаКлиенте
Процедура ВыводитьКонтактнуюИнформациюПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Организация", "Доступность", Объект.ВыводитьКонтактнуюИнформацию);
	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода УказатьДатуФормирования.
//
&НаКлиенте
Процедура УказатьДатуФормированияПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ДатаФормирования", "Доступность", Объект.ВыводитьДатуФормирования);
	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ТипЦены.
//
&НаКлиенте
Процедура ТипЦеныПриИзменении(Элемент)
	
	Если Объект.ТипыЦен.Количество() > 0 Тогда
			
		Объект.Валюта = ПолучитьВалютуЦены(Объект.ТипЦены);
			
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УправлениеСвойствамиЭлементовФормы()
	
	Если Объект.ПечатьПрайсЛиста = КэшЗначений.Полотно Тогда
		
		Элементы.СтраницыТипЦен.ТекущаяСтраница = Элементы.СтраницаТипЦенСписок;
		Элементы.ДекорацияОбразецПрайсЛиста.Картинка = БиблиотекаКартинок.ВариантПрайслистаПолотно;
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Валюта", "Доступность", Истина);
		
	ИначеЕсли Объект.ПечатьПрайсЛиста = КэшЗначений.ДвеКолонки Тогда
		
		Элементы.СтраницыТипЦен.ТекущаяСтраница = Элементы.СтраницаТипЦенЗапись;
		Элементы.ДекорацияОбразецПрайсЛиста.Картинка = БиблиотекаКартинок.ВариантПрайслистаКолонки;
		
	ИначеЕсли Объект.ПечатьПрайсЛиста = КэшЗначений.Диафильм Тогда
		
		Элементы.СтраницыТипЦен.ТекущаяСтраница = Элементы.СтраницаТипЦенЗапись;
		Элементы.ДекорацияОбразецПрайсЛиста.Картинка = БиблиотекаКартинок.ВариантПрайслистаДиафильм;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВариантПечатиПрайсЛиста()
	
	Если Объект.ПечатьПрайсЛиста = КэшЗначений.Полотно Тогда
		
		// не используется...
		
	ИначеЕсли Объект.ПечатьПрайсЛиста = КэшЗначений.ДвеКолонки Тогда
		
		Для каждого Строка Из Объект.ПредставлениеНоменклатуры Цикл
			
			Строка.Использование = (Строка.РеквизитНоменклатуры = "Наименование");
			
		КонецЦикла;
		ЗаполнитьПредставлениеНоменклатуры();
		
		Объект.ФормироватьПоНаличию = Ложь;
		
	ИначеЕсли Объект.ПечатьПрайсЛиста = КэшЗначений.Диафильм Тогда
		
		Для каждого Строка Из Объект.ПредставлениеНоменклатуры Цикл
			
			Строка.Использование = (Строка.РеквизитНоменклатуры = "НаименованиеПолное");
			
		КонецЦикла;
		ЗаполнитьПредставлениеНоменклатуры();
		
	КонецЕсли;
	
	УправлениеСвойствамиЭлементовФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПредставлениеНоменклатуры()
	
	СоставРеквизитов = "";
	Для каждого Строка Из Объект.ПредставлениеНоменклатуры Цикл
		
		Если Строка.Использование Тогда
			
			СоставРеквизитов = СоставРеквизитов + ?(ПустаяСтрока(СоставРеквизитов), "", ", ") + Строка.РеквизитПредставление;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если Объект.ПечатьПрайсЛиста = КэшЗначений.Диафильм Тогда
		
		СоставРеквизитов = СоставРеквизитов + НСтр("ru = ', Колонок: '") + Объект.КоличествоКолонок + НСтр("ru = ', Размер: '") + Объект.КартинкаШирина + НСтр("ru = ' х '") + Объект.КартинкаВысота;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьВалютуЦены(ТипЦены)
	
	Возврат ТипЦены.ВалютаЦены;
	
КонецФункции

&НаКлиенте
Процедура УдалитьИзбыточныеСтроки(Отказ)
	
	КоличествоВидовЦен = Объект.ТипыЦен.Количество();
	Если КоличествоВидовЦен > 1 Тогда
		
		Пока КоличествоВидовЦен > 1 Цикл
			
			Объект.ТипыЦен.Удалить(КоличествоВидовЦен - 1);
			
			КоличествоВидовЦен = КоличествоВидовЦен - 1;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
