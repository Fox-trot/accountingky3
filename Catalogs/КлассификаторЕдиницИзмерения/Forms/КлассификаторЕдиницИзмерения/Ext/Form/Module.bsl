﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Дерево = Справочники.КлассификаторЕдиницИзмерения.ПолучитьДанныеКлассификатора();
	
	Дерево.Колонки.Добавить("Выбран",     Новый ОписаниеТипов("Булево"));
	Дерево.Колонки.Добавить("Существует", Новый ОписаниеТипов("Булево"));
	
	Соответствие = Новый Соответствие;
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КлассификаторЕдиницИзмерения.Ссылка КАК Ссылка,
	|	КлассификаторЕдиницИзмерения.Код КАК Код
	|ИЗ
	|	Справочник.КлассификаторЕдиницИзмерения КАК КлассификаторЕдиницИзмерения";
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Соответствие.Вставить(Выборка.Код, Выборка.Код);
	КонецЦикла;
	
	Для каждого СтрокаУровень1 Из Дерево.Строки Цикл
		Для каждого СтрокаУровень2 Из СтрокаУровень1.Строки Цикл
			Для каждого СтрокаУровень3 Из СтрокаУровень2.Строки Цикл
				Если Соответствие.Получить(СтрокаУровень3.КодЧисловой) <> Неопределено Тогда
					СтрокаУровень3.Существует = Истина;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(Дерево, "ДеревоКлассификатора");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДеревоКлассификатораВыбранПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ДеревоКлассификатора.ТекущиеДанные;
	ВыбранПриИзменении(ТекущиеДанные);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ОбработатьРезультатыПодбораНаСервере();
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбработатьРезультатыПодбораНаСервере()
	
	МассивВыбранныхСтрок = Новый Массив;
	МассивКодов = Новый Массив;
	
	Дерево = РеквизитФормыВЗначение("ДеревоКлассификатора");
	Для каждого СтрокаУровень1 Из Дерево.Строки Цикл
		Если СтрокаУровень1.Выбран Тогда
			Для каждого СтрокаУровень2 Из СтрокаУровень1.Строки Цикл
				Если СтрокаУровень2.Выбран Тогда
					Для каждого СтрокаУровень3 Из СтрокаУровень2.Строки Цикл
						Если СтрокаУровень3.Выбран Тогда
						
							МассивВыбранныхСтрок.Добавить(СтрокаУровень3);
							МассивКодов.Добавить(СтрокаУровень3.КодЧисловой);
							
						КонецЕсли;
					КонецЦикла;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КлассификаторЕдиницИзмерения.Ссылка КАК Ссылка,
	|	КлассификаторЕдиницИзмерения.Код КАК Код
	|ИЗ
	|	Справочник.КлассификаторЕдиницИзмерения КАК КлассификаторЕдиницИзмерения
	|ГДЕ
	|	КлассификаторЕдиницИзмерения.Код В(&МассивКодов)";
	
	Запрос.УстановитьПараметр("МассивКодов", МассивКодов);
	
	ТаблицаЕдиницыИзмерения = Запрос.Выполнить().Выгрузить();
	ТаблицаЕдиницыИзмерения.Индексы.Добавить("Код");
	
	НачатьТранзакцию();
	Попытка
		Для каждого СтрокаДерева Из МассивВыбранныхСтрок Цикл
			НайденныйЭлемент = ТаблицаЕдиницыИзмерения.Найти(СтрокаДерева.КодЧисловой, "Код");
			Если НайденныйЭлемент <> Неопределено Тогда
				СправочникОбъект = НайденныйЭлемент.Ссылка.ПолучитьОбъект();
			Иначе
				СправочникОбъект = Справочники.КлассификаторЕдиницИзмерения.СоздатьЭлемент();
			КонецЕсли;
			Если ЗначениеЗаполнено(СтрокаДерева.УсловноеОбозначениеНациональное) Тогда
				Наименование = СтрокаДерева.УсловноеОбозначениеНациональное;
			ИначеЕсли ЗначениеЗаполнено(СтрокаДерева.УсловноеОбозначениеМеждународное) Тогда
				Наименование = СтрокаДерева.УсловноеОбозначениеМеждународное;
			ИначеЕсли ЗначениеЗаполнено(СтрокаДерева.КодовоеБуквенноеОбозначениеНациональное) Тогда
				Наименование = СтрокаДерева.КодовоеБуквенноеОбозначениеНациональное;
			ИначеЕсли ЗначениеЗаполнено(СтрокаДерева.КодовоеБуквенноеОбозначениеМеждународное) Тогда
				Наименование = СтрокаДерева.КодовоеБуквенноеОбозначениеМеждународное;
			Иначе
				Наименование = СтрокаДерева.Наименование;
			КонецЕсли;
			СправочникОбъект.Наименование            = СтрЗаменить(Наименование,Символы.ПС,"/");
			СправочникОбъект.МеждународноеСокращение = СтрЗаменить(СтрокаДерева.КодовоеБуквенноеОбозначениеМеждународное,Символы.ПС,"/");
			СправочникОбъект.НаименованиеПолное      = СтрЗаменить(СтрокаДерева.Наименование,Символы.ПС,"/");
			СправочникОбъект.Код                     = СтрокаДерева.КодЧисловой;
			БухгалтерскийУчетСервер.ЗаписатьСправочникОбъект(СправочникОбъект);
		КонецЦикла;
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбходДереваВверх(ТекущиеДанные)

	Родитель = ТекущиеДанные.ПолучитьРодителя();
	Если Родитель <> Неопределено Тогда // Верхний уровень
		
		ДочерниеСтроки = Родитель.ПолучитьЭлементы();
		КоличествоВыбранных = 0;
		ОбщееКоличество = 0;
		Для каждого Элемент Из ДочерниеСтроки Цикл
			Если Элемент.Выбран = 2 Тогда
				КоличествоВыбранных = КоличествоВыбранных + 0.5;
			ИначеЕсли Элемент.Выбран = 1 Тогда
				КоличествоВыбранных = КоличествоВыбранных + 1;
			КонецЕсли;
			ОбщееКоличество = ОбщееКоличество + 1;
		КонецЦикла;
		
		Если ОбщееКоличество = КоличествоВыбранных Тогда
			Родитель.Выбран = 1;
		ИначеЕсли КоличествоВыбранных = 0 Тогда
			Родитель.Выбран = 0;
		Иначе
			Родитель.Выбран = 2;
		КонецЕсли;
		
		ОбходДереваВверх(Родитель);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбходДереваВниз(ТекущиеДанные)
	
	ДочерниеСтроки = ТекущиеДанные.ПолучитьЭлементы();
	Для каждого Элемент Из ДочерниеСтроки Цикл
		Элемент.Выбран = ТекущиеДанные.Выбран;
		ОбходДереваВниз(Элемент);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбранПриИзменении(ТекущиеДанные)
	
	Если ТекущиеДанные.Выбран = 2 Тогда
		ТекущиеДанные.Выбран = 0;
	КонецЕсли;
	
	ОбходДереваВверх(ТекущиеДанные);
	ОбходДереваВниз(ТекущиеДанные);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоКлассификатораКодЧисловой.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоКлассификатораУсловноеОбозначениеНациональное.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоКлассификатораУсловноеОбозначениеМеждународное.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоКлассификатораКодовоеБуквенноеОбозначениеНациональное.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоКлассификатораКодовоеБуквенноеОбозначениеМеждународное.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоКлассификатораВесоваяЕдиницаИзмерения.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоКлассификатора.КодЧисловой");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("Отображать", Ложь);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоКлассификатора.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоКлассификатора.КодЧисловой");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт(WindowsШрифты.ШрифтДиалоговИМеню, , , Истина, Ложь, Ложь, Ложь, ));

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоКлассификатора.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоКлассификатора.Существует");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.ТемноГрифельноСиний);

КонецПроцедуры

#КонецОбласти
