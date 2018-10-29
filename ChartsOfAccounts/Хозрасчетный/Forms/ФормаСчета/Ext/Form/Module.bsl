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
	
	ПарныйСчет = Объект.ПарныйСчет;

	УстановитьПараметрыВыбораПарногоСчета();	
	
	Если Параметры.Ключ.Пустая() 
		И Параметры.ЗначениеКопирования.Пустая() Тогда
		Объект.Валютный       = Ложь;
		Объект.Количественный = Ложь;
	КонецЕсли;
	
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
	
	// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
КонецПроцедуры

// Процедура - обработчик события ПослеЗаписиНаСервере формы.
//
&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	// Контроль на заполнение парных счетов
	ПроверкаЗаполненияПарныхСчетов(Отказ);
КонецПроцедуры

// Процедура - обработчик события ПослеЗаписиНаСервере формы.
//
&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	// Обновление данных парного счета
	Если ПарныйСчет = ТекущийОбъект.ПарныйСчет Тогда 
		Возврат;
	КонецЕсли;	
	
	// Удаление старой связи
	Если НЕ ПарныйСчет.Пустая() Тогда 
		ПарныйСчетОбъект = ПарныйСчет.ПолучитьОбъект();
		ПарныйСчетОбъект.ПарныйСчет = ПланыСчетов.Хозрасчетный.ПустаяСсылка();	
		
		Попытка
			ПарныйСчетОбъект.Записать();
		Исключение
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Не удалось завершить запись по причине: %1'"), ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,,Отказ);				
			
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), 
				УровеньЖурналаРегистрации.Ошибка,,, ТекстСообщения);
			Возврат;	
		КонецПопытки;
	КонецЕсли;	
	
	// Установка новой связи	
	Если НЕ ТекущийОбъект.ПарныйСчет.Пустая() Тогда 
		ПарныйСчетОбъект = ТекущийОбъект.ПарныйСчет.ПолучитьОбъект();
		ПарныйСчетОбъект.ПарныйСчет = Объект.Ссылка;
		
		Попытка
			ПарныйСчетОбъект.Записать();
			ПарныйСчет = ТекущийОбъект.ПарныйСчет
		Исключение
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Не удалось завершить запись по причине: %1'"), ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,,Отказ);				
			
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), 
				УровеньЖурналаРегистрации.Ошибка,,, ТекстСообщения);
			КонецПопытки;
	КонецЕсли;	

КонецПроцедуры

// Процедура - обработчик события ПослеЗаписиНаСервере.
//
&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Процедура - обработчик события ПриИзменении поля ввода Код.
//
&НаКлиенте
Процедура КодПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Возврат;
	КонецЕсли;	
	
	// Если задан субсчет, то в его коде должна быть точка
	Код      = Объект.Код;
	Родитель = Объект.Родитель;
	
	Если Найти(Код, ".") > 0 Тогда
		
		//Найдем код родителя, для этого найдем последнюю точку в коде счета
		ПозицияТочки = СтрДлина(Код);
		
		Пока Сред(Код, ПозицияТочки, 1) <> "." Цикл
			
			ПозицияТочки = ПозицияТочки - 1;
			
		КонецЦикла;
		
		КодРодителя    = Лев(Код, ПозицияТочки - 1);
		РодительПоКоду = НайтиРодителя(КодРодителя);
		
		Если НЕ ЗначениеЗаполнено(РодительПоКоду) Тогда
			
			ПоказатьПредупреждение( , "План счетов не содержит счета с кодом " + КодРодителя);
			
		ИначеЕсли РодительПоКоду <> Объект.Ссылка Тогда
			
			СвойстваТекущегоРодителя = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(Объект.Родитель);
			
			Объект.Родитель       = РодительПоКоду;
			Объект.Вид            = СвойстваТекущегоРодителя.Вид;
			Объект.Забалансовый   = СвойстваТекущегоРодителя.Забалансовый;
			Объект.Количественный = СвойстваТекущегоРодителя.Количественный;
			Объект.Валютный       = СвойстваТекущегоРодителя.Валютный;
			
			Элементы.ВидыСубконтоВалютный.Видимость       = Объект.Валютный;
			Элементы.ВидыСубконтоКоличественный.Видимость = Объект.Количественный;
			
		КонецЕсли;
		
	КонецЕсли;
	//
	//Объект.КодБыстрогоВыбора = СокрЛП(СтрЗаменить(Код, ".", ""));
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Валютный.
//
&НаКлиенте
Процедура ВалютныйПриИзменении(Элемент)
	
	Элементы.ВидыСубконтоВалютный.Видимость = Объект.Валютный;
	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Количественный.
//
&НаКлиенте
Процедура КоличественныйПриИзменении(Элемент)
	
	Элементы.ВидыСубконтоКоличественный.Видимость = Объект.Количественный;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицФормы

&НаКлиенте
Процедура ВидыСубконтоПриИзменении(Элемент)
	УстановитьПараметрыВыбораПарногоСчета();	
КонецПроцедуры

&НаКлиенте
Процедура ВидыСубконтоПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Если Объект.Предопределенный Тогда
	  Отказ = Истина;	
	КонецЕсли;
	
	Если ЗапрещенныйСчет Тогда
		ПредупреждениеОНевозможностиИзмененияСоставаВидовСубконто(Отказ);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидыСубконтоПередНачаломИзменения(Элемент, Отказ)
	
	Если ЗапрещенныйСчет Тогда
		ПредупреждениеОНевозможностиИзмененияСоставаВидовСубконто(Отказ);
	КонецЕсли;
	
	Если Элемент.ТекущиеДанные.Предопределенное Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидыСубконтоПередУдалением(Элемент, Отказ)
	
	Если ЗапрещенныйСчет Тогда
		ПредупреждениеОНевозможностиИзмененияСоставаВидовСубконто(Отказ);
	КонецЕсли;
	
	Если Элемент.ТекущиеДанные.Предопределенное Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидыСубконтоПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		Элемент.ТекущиеДанные.Суммовой       = Истина;
		Элемент.ТекущиеДанные.Валютный       = Истина;
		Элемент.ТекущиеДанные.Количественный = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидыСубконтоВидСубконтоПриИзменении(Элемент)
	УстановитьПараметрыВыбораПарногоСчета();	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура устанавливает видимость и доступность элементов.
//
&НаСервере
Процедура УстановитьВидимостьДоступностьЭлементов()
	ЗапрещенныйСчет = ЭтоЗапрещенныйСчет(Объект.Ссылка);
	
	Элементы.ВидыСубконтоДобавить.Доступность = НЕ ЗапрещенныйСчет;
	Элементы.ВидыСубконтоИзменить.Доступность = НЕ ЗапрещенныйСчет;
	Элементы.ВидыСубконтоУдалить.Доступность  = НЕ ЗапрещенныйСчет;
	
	Кнопка = Элементы.ВидыСубконто.КонтекстноеМеню.ПодчиненныеЭлементы.Найти("ВидыСубконтоКонтекстноеМенюДобавить");
	Если Кнопка <> Неопределено Тогда
		Кнопка.Доступность = НЕ ЗапрещенныйСчет;
	КонецЕсли;
	Кнопка = Элементы.ВидыСубконто.КонтекстноеМеню.ПодчиненныеЭлементы.Найти("ВидыСубконтоКонтекстноеМенюИзменить");
	Если Кнопка <> Неопределено Тогда
		Кнопка.Доступность = НЕ ЗапрещенныйСчет;
	КонецЕсли;
	Кнопка = Элементы.ВидыСубконто.КонтекстноеМеню.ПодчиненныеЭлементы.Найти("ВидыСубконтоКонтекстноеМенюУдалить");
	Если Кнопка <> Неопределено Тогда
		Кнопка.Доступность = НЕ ЗапрещенныйСчет;
	КонецЕсли;
	
	Элементы.Родитель.ТолькоПросмотр = Объект.Предопределенный;
	
	Элементы.Забалансовый.Доступность   = НЕ Объект.Предопределенный;
	Элементы.Количественный.Доступность = НЕ Объект.Предопределенный;
	Элементы.Валютный.Доступность       = НЕ Объект.Предопределенный;
	Элементы.Код.Доступность       		= НЕ Объект.Предопределенный;
	
	Элементы.ПарныйСчет.ТолькоПросмотр 	= НЕ Объект.Вид = ВидСчета.Активный
		Или Объект.Код = "1795"
		Или (Объект.Код >= "2000" И Объект.Код <= "2999");
		
	Если Объект.Код >= "1000" И Объект.Код <= "2999" Тогда 
		Элементы.ПарныйСчет.Видимость = Истина;
	Иначе 
		Элементы.ПарныйСчет.Видимость = Ложь;
	КонецЕсли;	
	
	// Проверка субконто ОС.
	НайденныеСтроки = Объект.ВидыСубконто.НайтиСтроки(Новый Структура("ВидСубконто", ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.ОсновныеСредства));
	Если НайденныеСтроки.Количество() > 0 Тогда 
		Элементы.ПарныйСчет.Заголовок = НСтр("ru = 'Счет износа'");
	Иначе 	
		Элементы.ПарныйСчет.Заголовок = "";	
	КонецЕсли;	
	
	Если Объект.Предопределенный Тогда
		Элементы.ВидыСубконто.КоманднаяПанель.ПодчиненныеЭлементы.ВидыСубконтоДобавить.Видимость = Ложь;
		Элементы.ВидыСубконто.КонтекстноеМеню.ПодчиненныеЭлементы.ВидыСубконтоКонтекстноеМенюДобавить.Видимость = Ложь;	
	КонецЕсли;

КонецПроцедуры 

&НаСервереБезКонтекста
Функция НайтиРодителя(КодРодителя)
	
	Возврат ПланыСчетов.Хозрасчетный.НайтиПоКоду(КодРодителя);
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьЗапрещенныеСчета()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Хозрасчетный.Ссылка КАК Счет
		|ИЗ
		|	ПланСчетов.Хозрасчетный КАК Хозрасчетный
		|ГДЕ
		|	Хозрасчетный.Предопределенный";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ЗапрещенныеСчета = РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Счет");
	
	Возврат Новый ФиксированныйМассив(ЗапрещенныеСчета);
	
КонецФункции

&НаКлиенте
Процедура ПредупреждениеОНевозможностиИзмененияСоставаВидовСубконто(Отказ)
	
	ПоказатьПредупреждение( , НСтр("ru = 'Состав видов субконто на этом счете определяется настройкой параметров учета.'"));
	Отказ = Истина;
	
КонецПроцедуры // ПредупреждениеОНевозможностиИзмененияСоставаВидовСубконто()

&НаСервереБезКонтекста
Функция ЭтоЗапрещенныйСчет(Счет)

	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("Ссылка"          , Счет);
	Запрос.УстановитьПараметр("СписокСчетов"    , ПолучитьЗапрещенныеСчета());
	Запрос.УстановитьПараметр("СписокИсключений", ПланыСчетов.Хозрасчетный.ПолучитьСчетаИсключения());
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Хозрасчетный.Ссылка КАК Ссылка
	|ИЗ
	|	ПланСчетов.Хозрасчетный КАК Хозрасчетный
	|ГДЕ
	|	Хозрасчетный.Ссылка = &Ссылка
	|	И Хозрасчетный.Ссылка В(&СписокСчетов)
	|	И НЕ Хозрасчетный.Ссылка В (&СписокИсключений)";
	ЗапрещенныйСчет = НЕ Запрос.Выполнить().Пустой();
	
	Возврат ЗапрещенныйСчет;

КонецФункции // ЭтоЗапрещенныйСчет()

&НаСервере
Процедура ПроверкаЗаполненияПарныхСчетов(Отказ)
	
	Если Объект.ПарныйСчет.Пустая() Тогда 
		Возврат;
	КонецЕсли;	
	
	// Выбранный парный счет уже назначен у другого счета
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Хозрасчетный.Ссылка КАК СчетУчета
		|ИЗ
		|	ПланСчетов.Хозрасчетный КАК Хозрасчетный
		|ГДЕ
		|	НЕ Хозрасчетный.Ссылка = &Ссылка
		|	И Хозрасчетный.ПарныйСчет = &ПарныйСчет";
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	Запрос.УстановитьПараметр("ПарныйСчет", Объект.ПарныйСчет);
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ТекстСообщения = СтрШаблон(НСтр("ru = 'Счет %1 является парным для %2. Невозможно сделать запись.'"),
			Объект.ПарныйСчет, Выборка.СчетУчета);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,,Отказ);
	КонецЦикла;
	
КонецПроцедуры // ПроверкаЗаполненияПарныхСчетов()

// Процедура - Установить параметры выбора парного счета
//
&НаСервере
Процедура УстановитьПараметрыВыбораПарногоСчета()

	// Установка параметровы выбора для парного счета
	НовыйМассивПараметров = Новый Массив;
	НовыйМассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Забалансовый", Ложь));
	НовыйМассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.ЗапретитьИспользоватьВПроводках", Ложь));
	НовыйМассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Временный", Ложь));
	НовыйМассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Валютный", Объект.Валютный));
	НовыйМассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Вид", ВидСчета.Пассивный));
	
	// Добавление отбора по сотаву субконто.
	// Субконто должны совпадать.
	// В случае если субконто нет, то выбираются все счета без субконто.
	// Так же если счет назначен парным у другого счета, то скравыем такой счет из списка выбора.
	ТекстЗапроса = 
		"ВЫБРАТЬ
		|	Хозрасчетный.ПарныйСчет КАК ПарныйСчет
		|ПОМЕСТИТЬ ВременнаяТаблицаПарныеСчета
		|ИЗ
		|	ПланСчетов.Хозрасчетный КАК Хозрасчетный
		|ГДЕ
		|	НЕ Хозрасчетный.ПарныйСчет = ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка)
		|	И НЕ Хозрасчетный.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Хозрасчетный.Ссылка КАК Ссылка
		|ИЗ
		|	ПланСчетов.Хозрасчетный КАК Хозрасчетный
		|ГДЕ
		|	НЕ Хозрасчетный.ПометкаУдаления
		|	И НЕ Хозрасчетный.Забалансовый
		|	И НЕ Хозрасчетный.ЗапретитьИспользоватьВПроводках
		|	И Хозрасчетный.ВидыСубконто.ВидСубконто В(&ВидСубконто)
		|	И НЕ Хозрасчетный.ВидыСубконто.ТолькоОбороты
		|	И НЕ Хозрасчетный.Ссылка В
		|				(ВЫБРАТЬ
		|					ВременнаяТаблицаПарныеСчета.ПарныйСчет КАК ПарныйСчет
		|				ИЗ
		|					ВременнаяТаблицаПарныеСчета КАК ВременнаяТаблицаПарныеСчета)
		|
		|СГРУППИРОВАТЬ ПО
		|	Хозрасчетный.Ссылка";	
	Если Объект.ВидыСубконто.Количество() = 0 Тогда 
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "Хозрасчетный.ВидыСубконто.ВидСубконто В(&ВидСубконто)", "Истина");
	Иначе 
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "КОЛИЧЕСТВО(Хозрасчетный.ВидыСубконто.ВидСубконто) = 0", "Истина");
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	
	МассивВидыСубконто = Новый Массив;
	Для Каждого СтрокаТаблицы Из Объект.ВидыСубконто Цикл
		// Исключение оборотных
		Если СтрокаТаблицы.ТолькоОбороты Тогда 
			Продолжить;
		КонецЕсли;
		
		МассивВидыСубконто.Добавить(СтрокаТаблицы.ВидСубконто);		
	КонецЦикла;

	Запрос.УстановитьПараметр("ВидСубконто", МассивВидыСубконто);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	МассивСчетов = Новый Массив;
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		МассивСчетов.Добавить(ВыборкаДетальныеЗаписи.Ссылка);
	КонецЦикла;
	
	НовыйМассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Ссылка", Новый ФиксированныйМассив(МассивСчетов)));
	
	Элементы.ПарныйСчет.ПараметрыВыбора = Новый ФиксированныйМассив(НовыйМассивПараметров);

КонецПроцедуры // УстановитьПараметрыВыбораПарногоСчета()

#КонецОбласти

#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	
	ЗапретРедактированияРеквизитовОбъектовКлиент.РазрешитьРедактированиеРеквизитовОбъекта(ЭтотОбъект);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов

#КонецОбласти