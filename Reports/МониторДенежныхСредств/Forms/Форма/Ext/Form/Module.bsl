﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Пользователь = Пользователи.ТекущийПользователь();
	Организация = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(Пользователь, "ОсновнаяОрганизация");
		Объект.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("Организация", Организация);
		
	Если Параметры.КлючНазначенияИспользования = "ЗапускМонитораИзДокумента" Тогда
		ДанныеФормыСтруктура  = Параметры.СтруктураДанных;
		СформироватьТабличныйДокументИзДокумента(Параметры.СтруктураДанных);
		ЗапускМонитораИзДокумента = Истина;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьВидимостьДоступностьЭлементов()
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СтПериодПриИзменении(Элемент)
	СформироватьТабличныйДокументНаСервере()
КонецПроцедуры

&НаКлиенте
Процедура ГруппаСтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаРасшифровка Тогда
		ВыбранноеЗначение = ДанныеДляРасшифровки(ИмяТекущейОбласти); 	
		Если ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
			СформироватьТабличныйДокументРасшифровкаНаСервере(ВыбранноеЗначение)
		КонецЕсли;	
	КонецЕсли;
	УстановитьВидимостьДоступностьЭлементов();	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТабличныйДокумент

&НаКлиенте
Процедура ТабличныйДокументПриАктивизацииОбласти(Элемент)
	ИмяТекущейОбласти = Элемент.ТекущаяОбласть.Текст
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сформировать(Команда)
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаРасшифровка Тогда
		ВыбранноеЗначение = ДанныеДляРасшифровки(ИмяТекущейОбласти); 	
		Если ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
			СформироватьТабличныйДокументРасшифровкаНаСервере(ВыбранноеЗначение)
		КонецЕсли;
	Иначе
		СформироватьТабличныйДокументНаСервере()	
	КонецЕсли;	
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Видимость и доступность всех элементов формы
//
&НаКлиенте
Процедура УстановитьВидимостьДоступностьЭлементов() 
	ЭтоСтраницаРасшифровки = Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаРасшифровка;
	Элементы.ТабличныйДокументДействия.Видимость 			= НЕ ЭтоСтраницаРасшифровки;
	Элементы.ТабличныйДокументРасшифровкаДействия.Видимость = ЭтоСтраницаРасшифровки;
	Элементы.ТабличныйДокумент.Видимость = НЕ ЗапускМонитораИзДокумента;	
КонецПроцедуры // УстановитьВидимостьДоступностьЭлементов()  

&НаСервере
Процедура СформироватьТабличныйДокументНаСервере()
	ТабличныйДокумент.Очистить();
	Документ = РеквизитФормыВЗначение("Объект");

	Документ.Организация = Организация;
	Документ.СформироватьТабличныйДокумент(ТабличныйДокумент, "Обороты", СтПериод);
	ЗапускМонитораИзДокумента = Ложь;
КонецПроцедуры

&НаСервере
Процедура СформироватьТабличныйДокументИзДокумента(СтруктураДанных)
	ТабличныйДокументРасшифровка.Очистить();
	Документ = РеквизитФормыВЗначение("Объект");
	Документ.СформироватьТабличныйДокументМониторИзДокумента(ТабличныйДокументРасшифровка, СтруктураДанных);	

КонецПроцедуры

&НаСервере
Процедура СформироватьТабличныйДокументРасшифровкаНаСервере(ВыбранноеЗначение)

	ТабличныйДокументРасшифровка.Очистить();
	Документ = РеквизитФормыВЗначение("Объект");
	Документ.Организация = Организация;
	Документ.Субконто1 = ВыбранноеЗначение;
	Документ.СформироватьТабличныйДокумент(ТабличныйДокументРасшифровка, "Расшифровка", СтПериод);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ДанныеДляРасшифровки(ИмяТекущейОбласти)

	ПолученнаяСсылка = Неопределено;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	БанковскиеСчета.Ссылка
		|ИЗ
		|	Справочник.БанковскиеСчета КАК БанковскиеСчета
		|ГДЕ
		|	БанковскиеСчета.Наименование = &ИмяТекущейОбласти
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	Кассы.Ссылка
		|ИЗ
		|	Справочник.Кассы КАК Кассы
		|ГДЕ
		|	Кассы.Наименование = &ИмяТекущейОбласти";
	
	Запрос.УстановитьПараметр("ИмяТекущейОбласти", ИмяТекущейОбласти);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		ПолученнаяСсылка = ВыборкаДетальныеЗаписи.Ссылка
	КонецЕсли;
	
	Возврат ПолученнаяСсылка;
	
КонецФункции // ДанныеДляРасшифровки(ИмяТекущейОбласти)()

#КонецОбласти

