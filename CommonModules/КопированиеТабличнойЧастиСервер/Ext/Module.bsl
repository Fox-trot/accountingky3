﻿////////////////////////////////////////////////////////////////////////////////
// Серверные процедуры и функции для копирования и вставки 
// строк табличных частей
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Устанавливает доступность кнопки вставки скопированных строк в зависимости от заполненности буфера обмена.
//
// Параметры:
//  ЭлементыФормы - ВсеЭлементыФормы - Элементы формы, на которой расположены кнопки копирования и вставки строк.
//  ИмяТЧ         - Строка - Имя таблицы формы, в которой буду производиться встака/копирование строк.
Процедура ПриСозданииНаСевере(ЭлементыФормы, ИмяТЧ) Экспорт
	
	ЕстьСкопированныеСтроки = ХранилищеОбщихНастроек.Загрузить("БуферОбменаТабличныеЧасти", "Строки") <> Неопределено;
	
	Если ТипЗнч(ИмяТЧ) = Тип("Массив") Тогда
		Для каждого Эл Из ИмяТЧ Цикл
			УстановитьВидимостьКнопок(ЭлементыФормы, Эл, ЕстьСкопированныеСтроки);
		КонецЦикла;
	Иначе
		УстановитьВидимостьКнопок(ЭлементыФормы, ИмяТЧ, ЕстьСкопированныеСтроки);
	КонецЕсли;
	
КонецПроцедуры

// Копирует выделенные строки табличной части в буфер обмена.
//
// Параметры:
//  ТЧ                      - ДанныеФормыКоллекция - Табличная часть, в которой происходит копирование строк.
//  ВыделенныеСтроки        - Массив - Массив идентификаторов выделенных строк табличной части.
//  КоличествоСкопированных - Число - Получит значение количества скопированных строк.
Процедура Копировать(ТЧ, ВыделенныеСтроки, КоличествоСкопированных) Экспорт
	
	СкопированныеСтроки = ТЧ.Выгрузить();
	
	Итератор = ТЧ.Количество() - 1;
	Пока Итератор >= 0 Цикл
		Идентификатор = ТЧ[Итератор].ПолучитьИдентификатор();
		Если ВыделенныеСтроки.Найти(Идентификатор) = Неопределено Тогда
			СкопированныеСтроки.Удалить(Итератор);
		КонецЕсли;
		
		Итератор = Итератор - 1;
	КонецЦикла;
	
	ХранилищеОбщихНастроек.Сохранить("БуферОбменаТабличныеЧасти", "Строки", СкопированныеСтроки);
	КоличествоСкопированных = СкопированныеСтроки.Количество();
	
КонецПроцедуры

// Вставляет строки табличной части из буфер обмена в табличную часть.
//
// Параметры:
//  Объект - ДанныеФормыСтруктура - Данные объекта, в котором расположена табличная часть.
//  ИмяТЧ  - Строка - Имя таблицы формы, в которой буду производиться встака/копирование строк.
//  ЭлементыФормы           - ВсеЭлементыФормы - Элементы формы, на которой расположена табличная часть.
//  КоличествоСкопированных - Число - Получит значение количества строк, находящихся в буфере обмена.
//  КоличествоВставленных   - Число - Получит значение количества вставленных строк.
Процедура Вставить(Объект, ИмяТЧ, ЭлементыФормы, КоличествоСкопированных, КоличествоВставленных) Экспорт
	
	Если ТипЗнч(ИмяТЧ) = Тип("Структура") Тогда
		ИмяЭлемента = ИмяТЧ.ИмяЭлемента;
		ИмяТЧ = ИмяТЧ.ИмяТЧ;
	Иначе
		ИмяЭлемента = ИмяТЧ;
	КонецЕсли;
	
	ТЧ = Объект[ИмяТЧ];
	ТЧМетаданные = Объект.Ссылка.Метаданные().ТабличныеЧасти[ИмяТЧ];
	
	ВыделенныеСтроки = ЭлементыФормы[ИмяЭлемента].ВыделенныеСтроки;
	ВыделенныеСтроки.Очистить();
	
	ДобавляемыеСтроки = ХранилищеОбщихНастроек.Загрузить("БуферОбменаТабличныеЧасти", "Строки");
	Если ДобавляемыеСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	КоличествоСкопированных = ДобавляемыеСтроки.Количество();
	
	ИсключаяКолонки = "";
	
	Для каждого РеквизитТЧ Из ТЧМетаданные.Реквизиты Цикл
		
		Если ДобавляемыеСтроки.Колонки.Найти(РеквизитТЧ.Имя) = Неопределено Тогда
			Если ЗначениеЗаполнено(ИсключаяКолонки) Тогда
				ИсключаяКолонки = ИсключаяКолонки + ",";
			КонецЕсли;
			ИсключаяКолонки = ИсключаяКолонки + РеквизитТЧ.Имя;
			Продолжить;
		КонецЕсли;
		
		ФункциональнаяОпция = Неопределено;
		РеквизитДоступен = ПроверитьДоступностьОбъекта(РеквизитТЧ, ФункциональнаяОпция);
		Если НЕ РеквизитДоступен Тогда
			Продолжить;
		КонецЕсли;
		
		Если РеквизитТЧ.Тип.СодержитТип(Тип("Булево")) Тогда
			Продолжить;
		КонецЕсли;
		
		ИтераторЗначений = 0;
		//Условие = "";
		ДопустимыеЗначения = Новый Массив;
		
		//ПредставлениеПараметраВыбора = "Строка." + РеквизитТЧ.Имя + ".";
		
		Если ЭлементыФормы.Найти(ИмяЭлемента + РеквизитТЧ.Имя) <> Неопределено Тогда
			ПараметрыВыбора = ЭлементыФормы[ИмяЭлемента + РеквизитТЧ.Имя].ПараметрыВыбора;
		Иначе
			ПараметрыВыбора = РеквизитТЧ.ПараметрыВыбора;
		КонецЕсли;
		
		Для каждого ПараметрВыбора Из ПараметрыВыбора Цикл
			
			Если СтрНайти(ПараметрВыбора.Имя, "Отбор.") <> 1 Тогда
				Продолжить;
			КонецЕсли;
			
			ПредставлениеРеквизита = Прав(ПараметрВыбора.Имя, СтрДлина(ПараметрВыбора.Имя) - СтрДлина("Отбор."));
			ПредставлениеПараметраВыбора = "Строка." + РеквизитТЧ.Имя + "." + ПредставлениеРеквизита;
			
			УсловиеРеквизита = "";
			
			Если ТипЗнч(ПараметрВыбора.Значение) = Тип("ФиксированныйМассив") ИЛИ ТипЗнч(ПараметрВыбора.Значение) = Тип("Массив") Тогда
				Для каждого ЗначениеРеквизита Из ПараметрВыбора.Значение Цикл
					
					Если ЗначениеЗаполнено(УсловиеРеквизита) Тогда
						УсловиеРеквизита = УсловиеРеквизита + "ИЛИ "
					КонецЕсли;
					
					ДопустимыеЗначения.Добавить(ЗначениеРеквизита);
					УсловиеРеквизита = УсловиеРеквизита + ПредставлениеПараметраВыбора + "=ДопустимыеЗначения[" + ИтераторЗначений + "] ";
					ИтераторЗначений = ИтераторЗначений + 1;
					
				КонецЦикла;
			Иначе
				ДопустимыеЗначения.Добавить(ПараметрВыбора.Значение);
				УсловиеРеквизита = УсловиеРеквизита + ПредставлениеПараметраВыбора + "=ДопустимыеЗначения[" + ИтераторЗначений + "] ";
				ИтераторЗначений = ИтераторЗначений + 1;
			КонецЕсли;
			
			УсловиеРеквизитаПоТипуИ = "";
			УсловиеРеквизитаПоТипуИЛИ = "";
			ТипыРеквизита = РеквизитТЧ.Тип.Типы();
			Если ТипыРеквизита.Количество() > 1 Тогда
				
				Для каждого Тип Из ТипыРеквизита Цикл
					
					ОбъектМетаданныхПоТипу = Метаданные.НайтиПоТипу(Тип);
					Если ОбъектМетаданныхПоТипу = Неопределено Тогда
						
						Если ЗначениеЗаполнено(УсловиеРеквизитаПоТипуИЛИ) Тогда
							УсловиеРеквизитаПоТипуИЛИ = УсловиеРеквизитаПоТипуИЛИ + " ИЛИ ";
						КонецЕсли;
						
						ДопустимыеЗначения.Добавить(Тип);
						УсловиеРеквизитаПоТипуИЛИ = УсловиеРеквизитаПоТипуИЛИ + "ТипЗнч(Строка." + РеквизитТЧ.Имя + ")" + "=ДопустимыеЗначения[" + ИтераторЗначений + "] ";
						ИтераторЗначений = ИтераторЗначений + 1;
						
					ИначеЕсли ОбщегоНазначения.ЭтоСправочник(ОбъектМетаданныхПоТипу)
						ИЛИ ОбщегоНазначения.ЭтоДокумент(ОбъектМетаданныхПоТипу) Тогда
						
						Если ОбъектМетаданныхПоТипу.Реквизиты.Найти(ПредставлениеРеквизита) = Неопределено Тогда
							
							Если ЗначениеЗаполнено(УсловиеРеквизитаПоТипуИЛИ) Тогда
								УсловиеРеквизитаПоТипуИЛИ = УсловиеРеквизитаПоТипуИЛИ + " ИЛИ ";
							КонецЕсли;
							
							ДопустимыеЗначения.Добавить(Тип);
							УсловиеРеквизитаПоТипуИЛИ = УсловиеРеквизитаПоТипуИЛИ + "ТипЗнч(Строка." + РеквизитТЧ.Имя + ")" + "=ДопустимыеЗначения[" + ИтераторЗначений + "] ";
							ИтераторЗначений = ИтераторЗначений + 1;
							
						Иначе
							
							Если ЗначениеЗаполнено(УсловиеРеквизитаПоТипуИ) Тогда
								УсловиеРеквизитаПоТипуИ = УсловиеРеквизитаПоТипуИ + " ИЛИ ";
							Иначе
								УсловиеРеквизитаПоТипуИ = УсловиеРеквизитаПоТипуИ + "(";
							КонецЕсли;
							
							ДопустимыеЗначения.Добавить(Тип);
							УсловиеРеквизитаПоТипуИ = УсловиеРеквизитаПоТипуИ + "ТипЗнч(Строка." + РеквизитТЧ.Имя + ")" + "=ДопустимыеЗначения[" + ИтераторЗначений + "] ";
							ИтераторЗначений = ИтераторЗначений + 1;
							
						КонецЕсли;
						
					КонецЕсли;
					
				КонецЦикла;
				
				УсловиеРеквизитаПоТипуИ = УсловиеРеквизитаПоТипуИ + ")";
				
				УсловиеРеквизита = СтрШаблон(
					"(%1 И (%2))%3",
					УсловиеРеквизитаПоТипуИ,
					УсловиеРеквизита,
					?(ЗначениеЗаполнено(УсловиеРеквизитаПоТипуИЛИ), " ИЛИ " + УсловиеРеквизитаПоТипуИЛИ, "")
				);
				
			КонецЕсли;
			
			//Условие = Условие + УсловиеРеквизита;
			//ДобавляемыеСтроки = НайтиПоУсловию(ДобавляемыеСтроки, РеквизитТЧ.Имя, Условие, РеквизитТЧ.Тип, ДопустимыеЗначения);
			ДобавляемыеСтроки = НайтиПоУсловию(ДобавляемыеСтроки, РеквизитТЧ.Имя, УсловиеРеквизита, РеквизитТЧ.Тип, ДопустимыеЗначения);
			
		КонецЦикла;
		
	КонецЦикла;
	
	КолонкиКоторыеНеКопируются = "СерийныеНомера, СерийныеНомераОприходование, КлючСвязи, КлючСвязиСерийныеНомера";
	
	Для каждого Строка Из ДобавляемыеСтроки Цикл
		
		НоваяСтрока = ТЧ.Добавить();
		
		ИсключаяКолонкиНовый = "";
		
		Для каждого Колонка Из ТЧМетаданные.Реквизиты Цикл
			Если СтрНайти(ИсключаяКолонки, Колонка.Имя) <> 0 Тогда
				Продолжить;
			КонецЕсли;
			
			Если СтрНайти(КолонкиКоторыеНеКопируются, Колонка.Имя) <> 0 Тогда
				ИсключаяКолонкиНовый = ИсключаяКолонкиНовый + "," + Колонка.Имя;
				Продолжить;
			КонецЕсли;
			
			Если НЕ Колонка.Тип.СодержитТип(ТипЗнч(Строка[Колонка.Имя])) Тогда
				ИсключаяКолонкиНовый = ИсключаяКолонкиНовый + "," + Колонка.Имя;
			КонецЕсли;
		КонецЦикла;
		
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка, , ИсключаяКолонкиНовый);
		
		ВыделенныеСтроки.Добавить(НоваяСтрока.ПолучитьИдентификатор());
		
	КонецЦикла;
	
	КоличествоВставленных = ДобавляемыеСтроки.Количество();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Осуществляет поиск строк таблицы значений, отвечающих заданныму условию одного реквизита таблицы.
//
// Параметры:
//  ТЗ                 - ТаблицаЗначний - Таблица значений, в которой необходимо произвести отбор строк.
//  РеквизитОтбора     - Строка - Имя реквизита.
//  Условие - Строка   - Логическое выражение.
//  ДопустимыеТипы     - ОписаниеТипов - Тип реквизита приемника.
//  ДопустимыеЗначения - Массив - Массив значений, которые может принимать указанный реквизит.
//                                Если реквизит
// Возвращаемое значение:
//  ТаблицаЗначений - Таблица значений, содержащая строки, отвечающие заданному условию.
Функция НайтиПоУсловию(ТЗ, РеквизитОтбора, Условие, ДопустимыеТипы, ДопустимыеЗначения)
	
	НоваяТЗ = ТЗ.СкопироватьКолонки();
	
	Для каждого Строка из ТЗ Цикл
		
		ПодходящаяСтрока = Ложь;
		
		Если НЕ ЗначениеЗаполнено(Строка[РеквизитОтбора]) Тогда
			ПодходящаяСтрока = Истина;
		ИначеЕсли ДопустимыеТипы.СодержитТип(ТипЗнч(Строка[РеквизитОтбора])) Тогда
			ПодходящаяСтрока = Вычислить(Условие);
		КонецЕсли;
		
		Если ПодходящаяСтрока Тогда
			НоваяСтрока = НоваяТЗ.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат НоваяТЗ;
	
КонецФункции

// Устанавливает доступность кнопок вставки и копирования строк в табличную часть.
Процедура УстановитьВидимостьКнопок(ЭлементыФормы, ИмяТЧ, ЕстьСкопированныеСтроки)
	
	ЭлементыФормы[ИмяТЧ + "КопироватьСтроки"].Доступность = Истина;
	
	Если ЕстьСкопированныеСтроки Тогда
		ЭлементыФормы[ИмяТЧ + "ВставитьСтроки"].Доступность = Истина;
	Иначе
		ЭлементыФормы[ИмяТЧ + "ВставитьСтроки"].Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

// Проверяет, входит ли реквизит в состав одной из функциональных опций и возвращает ее значение.
Функция ПроверитьДоступностьОбъекта(Объект, ФункциональнаяОпция)
	
	Для каждого ФункциональнаяОпция Из Метаданные.ФункциональныеОпции Цикл
		
		ЭлементСостава = ФункциональнаяОпция.Состав.Найти(Объект);
		Если ЭлементСостава <> Неопределено Тогда
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Если ЭлементСостава <> Неопределено Тогда
		Возврат ПолучитьФункциональнуюОпцию(ФункциональнаяОпция.Имя);
	КонецЕсли;
	
	ФункциональнаяОпция = Неопределено;
	Возврат Истина;
	
КонецФункции

#КонецОбласти




